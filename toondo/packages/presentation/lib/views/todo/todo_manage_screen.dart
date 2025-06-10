import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:domain/usecases/todo/fetch_todos.dart';
import 'package:domain/usecases/todo/delete_todo.dart';
import 'package:domain/usecases/todo/get_all_todos.dart';
import 'package:domain/usecases/todo/update_todo_status.dart';
import 'package:domain/usecases/todo/update_todo_dates.dart';
import 'package:domain/usecases/goal/get_goals_local.dart';
import 'package:presentation/viewmodels/todo/todo_manage_viewmodel.dart';
import 'package:presentation/views/todo/todo_manage_scaffold.dart';

class TodoManageScreen extends StatelessWidget {
  final DateTime? selectedDate;
  const TodoManageScreen({Key? key, this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoManageViewModel>(
      create: (_) => TodoManageViewModel(
        fetchTodosUseCase: GetIt.instance<FetchTodosUseCase>(),
        deleteTodoUseCase: GetIt.instance<DeleteTodoUseCase>(),
        getTodosUseCase: GetIt.instance<GetAllTodosUseCase>(),
        updateTodoStatusUseCase: GetIt.instance<UpdateTodoStatusUseCase>(),
        updateTodoDatesUseCase: GetIt.instance<UpdateTodoDatesUseCase>(),
        getGoalsLocalUseCase: GetIt.instance<GetGoalsLocalUseCase>(),
        initialDate: selectedDate,
      )..loadTodos(),
      child: const TodoManageScaffold(),
    );
  }
}