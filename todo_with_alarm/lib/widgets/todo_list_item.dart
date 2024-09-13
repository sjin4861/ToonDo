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
    // 수행 여부에 따른 아이콘 설정
    IconData statusIcon;
    Color statusColor;

    switch (todo.status) {
      case 'O':
        statusIcon = Icons.check_circle;
        statusColor = Colors.green;
        break;
      case 'X':
        statusIcon = Icons.cancel;
        statusColor = Colors.red;
        break;
      default:
        statusIcon = Icons.help;
        statusColor = Colors.grey;
    }

    return ListTile(
      leading: hideCompletionStatus
          ? null
          : Icon(
              statusIcon,
              color: statusColor,
            ),
      title: Text(todo.title),
      subtitle: hideCompletionStatus || todo.comment.isEmpty
          ? null
          : Text('코멘트: ${todo.comment}'),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: onDelete,
      ),
      onTap: () {
        // 투두 항목 클릭 시 다이얼로그 표시
        _showStatusDialog(context);
      },
    );
  }

  void _showStatusDialog(BuildContext context) {
    String? selectedStatus = todo.status;
    TextEditingController commentController =
        TextEditingController(text: todo.comment);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${todo.title} 수행 여부'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 수행 여부 선택 라디오 버튼
              Column(
                children: [
                  RadioListTile<String>(
                    title: Text('O (완료)'),
                    value: 'O',
                    groupValue: selectedStatus,
                    onChanged: (value) {
                      selectedStatus = value;
                      // 상태를 즉시 업데이트하지 않고, 확인 버튼 클릭 시 업데이트
                      (context as Element).markNeedsBuild();
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('X (미완료)'),
                    value: 'X',
                    groupValue: selectedStatus,
                    onChanged: (value) {
                      selectedStatus = value;
                      (context as Element).markNeedsBuild();
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('U (미확인)'),
                    value: 'U',
                    groupValue: selectedStatus,
                    onChanged: (value) {
                      selectedStatus = value;
                      (context as Element).markNeedsBuild();
                    },
                  ),
                ],
              ),
              // 코멘트 입력 필드
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  labelText: '코멘트 입력',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                // 수행 여부와 코멘트 업데이트
                Todo updatedTodo = Todo(
                  title: todo.title,
                  date: todo.date,
                  status: selectedStatus ?? 'U',
                  comment: commentController.text,
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