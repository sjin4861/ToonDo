import 'package:flutter/material.dart';
import 'package:presentation/views/todo/input/todo_input_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:domain/usecases/todo/create_todo.dart';
import 'package:domain/usecases/todo/update_todo.dart';
import 'package:domain/usecases/goal/get_goals_local.dart';
import 'package:domain/entities/todo.dart';
import 'package:presentation/viewmodels/todo/todo_input_viewmodel.dart';


class TodoInputScreen extends StatelessWidget {
  final bool isDDayTodo;
  final Todo? todo;

  const TodoInputScreen({super.key, this.isDDayTodo = true, this.todo});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoInputViewModel>(
      create: (_) => TodoInputViewModel(
        todo: todo,
        isDDayTodo: isDDayTodo,
        createTodoUseCase: GetIt.instance<CreateTodoUseCase>(),
        updateTodoUseCase: GetIt.instance<UpdateTodoUseCase>(),
        getGoalsLocalUseCase: GetIt.instance<GetGoalsLocalUseCase>(),
      ),
      child: const TodoInputScaffold(),
    );
  }
}
