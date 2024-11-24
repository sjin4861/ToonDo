

import 'package:flutter/material.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/viewmodels/todo/todo_input_viewmodel.dart';

class EditUpdateButton extends StatelessWidget {
  final TodoInputViewModel viewModel;
  final Todo? todo;

  EditUpdateButton({required this.viewModel, this.todo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: Key('submitTodoButton'),
      onTap: () {
        viewModel.saveTodo(context);
      },
      child: Container(
        width: double.infinity,
        height: 56,
        margin: EdgeInsets.symmetric(horizontal: 25),
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: ShapeDecoration(
          color: Color(0xFF78B545),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Center(
          child: Text(
            todo != null ? '수정하기' : '작성하기',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Pretendard Variable',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.24,
            ),
          ),
        ),
      ),
    );
  }
}