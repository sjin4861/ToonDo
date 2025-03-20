import 'package:flutter/material.dart';
import 'package:domain/entities/todo.dart';
import 'package:presentation/viewmodels/todo/todo_input_viewmodel.dart';
import 'custom_button.dart';

class EditUpdateButton extends StatelessWidget {
  final TodoInputViewModel viewModel;
  final Todo? todo;
  final Key key;
  final VoidCallback? onPressed;

  EditUpdateButton({required this.viewModel, this.todo, required this.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: todo != null ? '수정하기' : '작성하기',
      onPressed: () {
        viewModel.saveTodo(context);
      },
      backgroundColor: const Color(0xFF78B545),
      textColor: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.24,
      padding: 16.0,
      borderRadius: BorderRadius.circular(30),
    );
  }
}