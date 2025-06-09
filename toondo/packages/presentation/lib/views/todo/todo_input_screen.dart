import 'package:domain/entities/goal.dart';
import 'package:domain/usecases/goal/get_goals_local.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:domain/entities/todo.dart';
import 'package:domain/usecases/todo/create_todo.dart';
import 'package:domain/usecases/todo/update_todo.dart';
import 'package:presentation/viewmodels/todo/todo_input_viewmodel.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/bottom_button/edit_update_button.dart';
import 'package:presentation/widgets/goal/goal_list_dropdown.dart';
import 'package:presentation/widgets/todo/dday_daily_chip.dart';
import 'package:presentation/widgets/todo/eisenhower_button.dart';
import 'package:presentation/widgets/text_fields/tip.dart';
import 'package:presentation/widgets/todo/todo_input_date_field.dart';
import 'package:domain/entities/status.dart';

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
      child: Scaffold(
        backgroundColor: const Color(0xFFFCFCFC),
        appBar: CustomAppBar(title: todo != null ? '투두 수정' : '투두 작성'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Consumer<TodoInputViewModel>(
            builder: (context, viewModel, child) {
              return SingleChildScrollView(
                child: Form(
                  key: viewModel.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // D-Day / 데일리 토글 버튼
                      Align(
                        alignment: Alignment.centerRight,
                        child: DdayDailyChip(
                          isDailySelected: viewModel.isDailyTodo,
                          onToggle: (isDaily) {
                            viewModel.setDailyTodoStatus(isDaily);
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      // 투두 이름 입력 필드
                      _buildTextField('투두 이름', viewModel),
                      if (viewModel.goalNameError != null) ...[
                        const SizedBox(height: 4),
                        _buildErrorText(viewModel.goalNameError!),
                      ],
                      const SizedBox(height: 24),
                      // 목표 선택 위젯
                      _buildGoalSelection(viewModel, context),
                      const SizedBox(height: 24),
                      // 날짜 입력 필드 (데일리 투두가 아닐 경우)
                      if (!viewModel.isDailyTodo) _buildDateFields(viewModel),
                      const SizedBox(height: 24),
                      // 아이젠하워 매트릭스
                      _buildEisenhowerMatrix(viewModel),
                      const SizedBox(height: 24),
                      // TIP 위젯
                      const TipWidget(
                        title: 'TIP',
                        description:
                            '아이젠하워는 긴급도와 중요도에 따라 할 일을 정리하는 방법이에요.\n'
                            '앞으로 투두가 아이젠하워에 따라 가장 중요한 일부터 알려줄게요!',
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: Consumer<TodoInputViewModel>(
          builder: (context, viewModel, child) {
            return Padding(
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TodoInputViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF1C1D1B),
            fontSize: 10,
            fontFamily: 'Pretendard Variable',
            fontWeight: FontWeight.w400,
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1000),
              side: BorderSide(
                width: 1,
                color:
                    viewModel.isTitleNotEmpty
                        ? const Color(0xFF78B545)
                        : const Color(0xFFDDDDDD),
              ),
            ),
          ),
          child: TextFormField(
            controller: viewModel.titleController,
            maxLength: 20,
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              hintText: '투두의 이름을 입력하세요.',
              hintStyle: TextStyle(
                color: Color(0xFFB2B2B2),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.18,
                fontFamily: 'Pretendard Variable',
              ),
            ),
            style: const TextStyle(
              color: Color(0xFF1C1D1B),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.18,
              fontFamily: 'Pretendard Variable',
            ),
            // 변경: null 안전 연산자 사용하여 value가 null일 경우 빈 문자열 처리
            onSaved: (value) {
              viewModel.title = (value ?? '').trim();
            },
          ),
        ),
        if (!viewModel.isTitleNotEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              '투두 이름을 입력해주세요.',
              style: TextStyle(
                color: Color(0xFFEE0F12),
                fontSize: 10,
                fontFamily: 'Pretendard Variable',
                fontWeight: FontWeight.w400,
                letterSpacing: 0.15,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildErrorText(String error) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        error,
        style: const TextStyle(
          color: Color(0xFFEE0F12),
          fontSize: 10,
          fontFamily: 'Pretendard Variable',
          fontWeight: FontWeight.w400,
          letterSpacing: 0.15,
        ),
      ),
    );
  }

  Widget _buildGoalSelection(
    TodoInputViewModel viewModel,
    BuildContext context,
  ) {
    return FutureBuilder<List<Goal>>(
      future: viewModel.fetchGoals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Error loading goals');
        } else {
          // active 상태인 목표만 필터링
          final allGoals = snapshot.data ?? [];
          final activeGoals = allGoals.where((g) => g.status == Status.active).toList();
          return GoalListDropdown(
            selectedGoalId: viewModel.selectedGoalId,
            goals: activeGoals,
            isDropdownOpen: viewModel.showGoalDropdown,
            onGoalSelected: (goalId) {
              viewModel.selectGoal(goalId);
            },
            toggleDropdown: viewModel.toggleGoalDropdown,
          );
        }
      },
    );
  }

  Widget _buildDateFields(TodoInputViewModel viewModel) {
    return Column(
      children: [
        Row(
          children: [
            DateField(viewModel: viewModel, label: "시작일"),
            const SizedBox(width: 16),
            DateField(viewModel: viewModel, label: "마감일"),
          ],
        ),
      ],
    );
  }

  Widget _buildEisenhowerMatrix(TodoInputViewModel viewModel) {
    return Column(
      children: [
        const Text(
          '아이젠하워',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF1C1D1B),
            fontSize: 10,
            fontFamily: 'Pretendard Variable',
            fontWeight: FontWeight.w400,
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (index) {
            return EisenhowerButton(
              index: index,
              isSelected: viewModel.selectedEisenhowerIndex == index,
              onTap: () => viewModel.setEisenhower(index),
            );
          }),
        ),
      ],
    );
  }
}
