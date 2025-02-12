import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/data/models/todo.dart';
import 'package:todo_with_alarm/ui/todo/todo_input/todo_input_viewmodel.dart';
import 'package:todo_with_alarm/widgets/app_bar/custom_app_bar.dart';
import 'package:todo_with_alarm/widgets/bottom_button/edit_update_button.dart';
import 'package:todo_with_alarm/widgets/goal/goal_list_dropdown.dart';
import 'package:todo_with_alarm/widgets/todo/dday_daily_chip.dart';
import 'package:todo_with_alarm/widgets/todo/eisenhower_button.dart';
import 'package:todo_with_alarm/widgets/text_fields/tip.dart';
import 'package:todo_with_alarm/widgets/todo/todo_input_date_field.dart';

class TodoInputView extends StatelessWidget {
  final bool isDDayTodo;
  final Todo? todo;

  const TodoInputView({super.key, this.isDDayTodo = true, this.todo});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoInputViewModel>(
      create: (_) => TodoInputViewModel(todo: todo, isDDayTodo: isDDayTodo),
      child: Scaffold(
        backgroundColor: const Color(0xFFFCFCFC),
        appBar: CustomAppBar(
          title: todo != null ? '투두 수정' : '투두 작성',
        ),
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
                        description: '아이젠하워는 긴급도와 중요도에 따라 할 일을 정리하는 방법이에요.\n'
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
                color: viewModel.isTitleNotEmpty
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
            onSaved: (value) {
              viewModel.title = value!.trim();
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

  Widget _buildGoalSelection(TodoInputViewModel viewModel, BuildContext context) {
    // GoalListDropdown는 목표 선택 UI를 구성하는 커스텀 위젯입니다.
    return GoalListDropdown(
      selectedGoalId: viewModel.selectedGoalId,
      goals: const [], // ...기존 코드에서 목표 목록 전달...
      isDropdownOpen: viewModel.showGoalDropdown,
      onGoalSelected: (goalId) {
        viewModel.selectGoal(goalId);
      },
      toggleDropdown: viewModel.toggleGoalDropdown,
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
