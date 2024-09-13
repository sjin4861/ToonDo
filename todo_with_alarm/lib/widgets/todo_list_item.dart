// widgets/todo_list_item.dart

import 'package:flutter/material.dart';
import 'package:todo_with_alarm/models/todo.dart';

class TodoListItem extends StatefulWidget {
  final Todo todo;
  final Function(Todo) onUpdate; // 투두 항목이 업데이트될 때 호출되는 콜백

  const TodoListItem({Key? key, required this.todo, required this.onUpdate}) : super(key: key);

  @override
  _TodoListItemState createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  late String selectedStatus;
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.todo.status;
    commentController.text = widget.todo.comment;
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void _updateTodo() {
    setState(() {
      widget.todo.status = selectedStatus;
      widget.todo.comment = commentController.text;
    });
    widget.onUpdate(widget.todo); // 변경된 투두를 상위로 전달
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.todo.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상태 선택 드롭다운
          DropdownButton<String>(
            value: selectedStatus.isEmpty ? null : selectedStatus,
            hint: Text('상태 선택'),
            items: ['O', 'X', 'U'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newStatus) {
              if (newStatus != null) {
                setState(() {
                  selectedStatus = newStatus;
                });
                _updateTodo();
              }
            },
          ),
          // 코멘트 입력 필드
          TextField(
            controller: commentController,
            decoration: InputDecoration(
              labelText: '코멘트 입력',
            ),
            onChanged: (value) {
              _updateTodo();
            },
          ),
        ],
      ),
    );
  }
}