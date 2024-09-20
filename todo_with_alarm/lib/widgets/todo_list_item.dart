// widgets/todo_list_item.dart

import 'package:flutter/material.dart';
import 'package:todo_with_alarm/models/todo.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;
  final Function(Todo) onUpdate;
  final VoidCallback onDelete;
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
    // 진행률에 따른 색상 설정
    Color statusColor = _getStatusColor(todo.status);

    return ListTile(
      leading: hideCompletionStatus
          ? null
          : CircleAvatar(
              backgroundColor: statusColor,
              child: Text(
                '${todo.status.toStringAsFixed(1)}%',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
      title: Text(todo.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (todo.goalId != null && todo.goalId!.isNotEmpty)
            Text(
              '목표: ${todo.goalId}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          if (!hideCompletionStatus && todo.comment.isNotEmpty)
            Text('코멘트: ${todo.comment}'),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,
      ),
      onTap: () {
        // 투두 항목 클릭 시 진행률 업데이트 다이얼로그 표시
        _showStatusDialog(context);
      },
      isThreeLine: (todo.goalId != null && todo.goalId!.isNotEmpty) ||
          (!hideCompletionStatus && todo.comment.isNotEmpty),
    );
  }

  // 진행률에 따른 색상 반환 함수
  Color _getStatusColor(double status) {
    if (status >= 80.0) {
      return Colors.green;
    } else if (status >= 50.0) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  void _showStatusDialog(BuildContext context) {
    double selectedStatus = todo.status;
    TextEditingController commentController =
        TextEditingController(text: todo.comment);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${todo.title} 진행률 업데이트'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 진행률 슬라이더
              Text('진행률: ${selectedStatus.toStringAsFixed(1)}%'),
              Slider(
                value: selectedStatus,
                min: 0.0,
                max: 100.0,
                divisions: 1000, // 0.1 단위로 나누기
                label: '${selectedStatus.toStringAsFixed(1)}%',
                onChanged: (double value) {
                  selectedStatus = value;
                  (context as Element).markNeedsBuild();
                },
              ),
              SizedBox(height: 20),
              // 코멘트 입력 필드
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  labelText: '코멘트 입력',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                // 진행률과 코멘트 업데이트
                Todo updatedTodo = Todo(
                  title: todo.title,
                  date: todo.date,
                  status: selectedStatus,
                  comment: commentController.text,
                  goalId: todo.goalId, // 기존 목표 유지
                  urgency: todo.urgency, // 기존 긴급도 유지
                  importance: todo.importance, // 기존 중요도 유지
                );
                onUpdate(updatedTodo);
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}