import 'package:flutter/material.dart';
import 'package:presentation/designsystem/components/buttons/app_button.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/views/base_scaffold.dart';
import 'package:presentation/views/todo/input/todo_input_body.dart';
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
  final bool isOnboarding;

  const TodoInputScreen({super.key, this.isDDayTodo = true, this.todo, this.isOnboarding = false});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoInputViewModel>(
      create:
          (_) => TodoInputViewModel(
            todo: todo,
            isDDayTodo: isDDayTodo,
            isOnboarding: isOnboarding,
            createTodoUseCase: GetIt.instance<CreateTodoUseCase>(),
            updateTodoUseCase: GetIt.instance<UpdateTodoUseCase>(),
            getGoalsLocalUseCase: GetIt.instance<GetGoalsLocalUseCase>(),
          ),
      child: BaseScaffold(
        body: TodoInputBody(),
        title: isOnboarding
            ? '시작하기'
            : (todo != null ? '투두 수정' : '투두 작성'),
        bottomWidget: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacing24,
              vertical: AppSpacing.spacing8,
            ),
            child: Builder(
              builder:
                  (context) => AppButton(
                    label: todo != null ? '수정하기' : '작성하기',
                    onPressed: () {
                      final viewModel = context.read<TodoInputViewModel>();
                      if (todo != null) {
                        viewModel.updateTodo(
                          onSuccess: () => Navigator.pop(context),
                          onError: (msg) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(msg)));
                          },
                        );
                      } else {
                        viewModel.createTodo(
                          onSuccess: () => Navigator.pop(context),
                          onError: (msg) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(msg)));
                          },
                        );
                      }
                    },
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
