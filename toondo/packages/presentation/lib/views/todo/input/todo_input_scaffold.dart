import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/todo/todo_input_viewmodel.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/bottom_button/edit_update_button.dart';
import 'package:provider/provider.dart';
import 'todo_input_body.dart';

class TodoInputScaffold extends StatelessWidget {
  const TodoInputScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TodoInputViewModel>();
    final todo = viewModel.todo;

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      appBar: CustomAppBar(title: todo != null ? '투두 수정' : '투두 작성'),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: TodoInputBody(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: EditUpdateButton(
          key: const Key('editUpdateButton'),
          viewModel: viewModel,
          todo: todo,
          onPressed: () {
            if (viewModel.formKey.currentState!.validate()) {
              viewModel.saveTodo(context);
            }
          },
        ),
      ),
    );
  }
}
