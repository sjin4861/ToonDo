// widgets/todo_list_item.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_viewmodel.dart';
class TodoListItem extends StatelessWidget {
  final Todo todo;
  final Function(Todo) onUpdate;
  final Function() onDelete;
  final bool hideCompletionStatus;

  const TodoListItem({
    Key? key,
    required this.todo,
    required this.onUpdate,
    required this.onDelete,
    this.hideCompletionStatus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Todo>(
      builder: (context, todo, child) {
        // 진행률 표시 위젯
        Widget progressIndicator = hideCompletionStatus
            ? SizedBox.shrink()
            : SizedBox(
                width: 40,
                height: 40,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: todo.status / 100,
                      strokeWidth: 4,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                    Center(
                      child: Text(
                        '${todo.status.toInt()}%',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );

        return ListTile(
          leading: progressIndicator,
          title: Text(todo.title),
          subtitle: _buildSubtitle(context),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: onDelete,
          ),
          onTap: () {
            // 진행률 업데이트 다이얼로그 표시
            _showProgressDialog(context);
          },
        );
      },
    );
  }

  Widget? _buildSubtitle(BuildContext context) {
    // 목표 이름 가져오기
    String? goalName;
    if (todo.goalId != null) {
      final goalViewmodel = Provider.of<GoalViewModel>(context, listen: false);
      final matchingGoals =
          goalViewmodel.goals.where((goal) => goal.id == todo.goalId);
      if (matchingGoals.isNotEmpty) {
        goalName = matchingGoals.first.name;
      } else {
        // 목표를 찾지 못한 경우 처리
        goalName = '목표를 찾을 수 없음';
      }
    }

    if (goalName != null) {
      return Text('목표: $goalName');
    } else {
      return null;
    }
  }

  // 진행률 업데이트 다이얼로그 메서드
  void _showProgressDialog(BuildContext context) {
    double newStatus = todo.status;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('진행률 업데이트'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('진행률: ${newStatus.toInt()}%'),
                  Slider(
                    value: newStatus,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: '${newStatus.toInt()}%',
                    onChanged: (double value) {
                      setStateDialog(() {
                        newStatus = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('취소'),
                ),
                TextButton(
                  onPressed: () {
                    // 진행률 업데이트
                    todo.updateStatus(newStatus);
                    onUpdate(todo);
                    Navigator.pop(context);
                  },
                  child: Text('저장'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}