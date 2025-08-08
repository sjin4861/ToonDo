import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/views/base_scaffold.dart';
import 'package:presentation/views/todo/manage/todo_manage_body.dart';
import 'package:provider/provider.dart';
import 'package:domain/usecases/todo/delete_todo.dart';
import 'package:domain/usecases/todo/get_all_todos.dart';
import 'package:domain/usecases/todo/update_todo_status.dart';
import 'package:domain/usecases/todo/update_todo_dates.dart';
import 'package:domain/usecases/goal/get_goals_local.dart';
import 'package:presentation/viewmodels/todo/todo_manage_viewmodel.dart';

class TodoManageScreen extends StatelessWidget {
  final DateTime? selectedDate;

  const TodoManageScreen({super.key, this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoManageViewModel>(
      create:
          (_) => TodoManageViewModel(
            deleteTodoUseCase: GetIt.instance<DeleteTodoUseCase>(),
            getTodosUseCase: GetIt.instance<GetAllTodosUseCase>(),
            updateTodoStatusUseCase: GetIt.instance<UpdateTodoStatusUseCase>(),
            updateTodoDatesUseCase: GetIt.instance<UpdateTodoDatesUseCase>(),
            getGoalsLocalUseCase: GetIt.instance<GetGoalsLocalUseCase>(),
            initialDate: selectedDate,
          )..loadTodos(),
      child: BaseScaffold(
        body: TodoManageBody(),
        title: '투두리스트',
        bottomWidget: _buildBottomSpacer(),
      ),
    );
  }

  Widget _buildBottomSpacer() {
    return Container(
      height: AppDimensions.bottomNavBarHeight,
      decoration: const BoxDecoration(
        color: AppColors.backgroundNormal,
        border: Border(
          top: BorderSide(width: 1, color: AppColors.status100_25),
        ),
      ),
    );
  }
}
