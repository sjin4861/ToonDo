// widgets/todo_circle.dart

import 'package:flutter/material.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/utils/color_utils.dart'; // 추가

class TodoCircle extends StatelessWidget {
  final Todo todo;

  const TodoCircle({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: getColor(todo),
      child: Text(
        todo.title.isNotEmpty ? todo.title[0].toUpperCase() : 'T',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}