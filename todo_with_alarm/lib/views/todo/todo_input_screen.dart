// lib/views/todo/todo_input_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/services/todo_service.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_viewmodel.dart';
import 'package:todo_with_alarm/viewmodels/todo/todo_input_viewmodel.dart';
import 'package:todo_with_alarm/widgets/app_bar/custom_app_bar.dart';
import 'package:todo_with_alarm/widgets/bottom_button/edit_update_button.dart';
import 'package:todo_with_alarm/widgets/goal/goal_list_dropdown.dart';
import 'package:todo_with_alarm/widgets/todo/dday_daily_chip.dart';
import 'package:todo_with_alarm/widgets/todo/eisenhower_button.dart';
import 'package:todo_with_alarm/widgets/text_fields/tip.dart';
import 'package:todo_with_alarm/widgets/todo/todo_input_date_field.dart';

// TodoInputScreen 클래스는 투두 입력 화면을 구성합니다.
class TodoInputScreen extends StatelessWidget {
  final bool isDDayTodo; // D-Day 투두 여부
  final Todo? todo; // 수정할 투두 객체

  const TodoInputScreen({super.key, this.isDDayTodo = true, this.todo});

  @override
  Widget build(BuildContext context) {
    // TodoService를 Provider로부터 가져옵니다.
    final TodoService todoService =
        Provider.of<TodoService>(context, listen: false);

    return ChangeNotifierProvider<TodoInputViewModel>(
      // TodoInputViewModel을 생성하여 Provider로 제공합니다.
      create: (_) => TodoInputViewModel(
          todo: todo, isDDayTodo: isDDayTodo, todoService: todoService),
      child: Scaffold(
        backgroundColor: const Color(0xFFFCFCFC),
        appBar: CustomAppBar(
          title: todo != null ? '투두 수정' : '투두 작성', // AppBar의 제목 설정
        ),
        body: Consumer<TodoInputViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: viewModel.formKey, // Form의 key 설정
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      _buildToggleButtons(viewModel), // D-Day와 데일리 토글 버튼
                      const SizedBox(height: 24),
                      _buildTextField('투두 이름', viewModel.titleController,
                          viewModel.isTitleNotEmpty, viewModel), // 투두 이름 입력 필드
                      if (viewModel.goalNameError != null)
                        _buildErrorText(
                            viewModel.goalNameError!), // 목표 이름 에러 메시지
                      const SizedBox(height: 24),
                      _buildGoalSelection(viewModel, context), // 목표 선택 위젯
                      const SizedBox(height: 24),
                      if (!viewModel.isDailyTodo)
                        _buildDateFields(viewModel), // 날짜 입력 필드 (데일리 투두가 아닐 경우)
                      const SizedBox(height: 24),
                      _buildEisenhowerMatrix(viewModel), // 아이젠하워 매트릭스
                      const SizedBox(height: 24),
                      const TipWidget(
                        title: 'TIP',
                        description: '아이젠하워는 긴급도와 중요도에 따라 할 일을 정리하는 방법이에요.\n'
                            '앞으로 툰두가 아이젠하워에 따라 가장 중요한 일부터 알려줄게요!',
                      ), // 팁 위젯
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
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
                    // 저장 로직
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

  // D-Day와 데일리 토글 버튼을 생성하는 메서드
  Widget _buildToggleButtons(TodoInputViewModel viewModel) {
    return Align(
      alignment: Alignment.centerRight,
      child: DdayDailyChip(
        isDailySelected: viewModel.isDailyTodo,
        onToggle: (isDaily) {
          viewModel.setDailyTodoStatus(isDaily);
        },
      ),
    );
  }

  // 투두 이름 입력 필드를 생성하는 메서드
  Widget _buildTextField(
      String label, TextEditingController controller, bool isNotEmpty, TodoInputViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF1C1D1B),
            fontSize: 10,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.15,
            fontFamily: 'Pretendard Variable',
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
                color: isNotEmpty
                    ? const Color(0xFF78B545)
                    : const Color(0xFFDDDDDD),
              ),
            ),
          ),
          child: TextFormField(
            controller: controller,
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
              viewModel.title = value!.trim(); // ViewModel의 title 설정
            },
          ),
        ),
        if (!isNotEmpty) ...[
          const SizedBox(height: 4),
          const Text(
            '투두 이름을 입력해주세요.',
            style: TextStyle(
              color: Color(0xFFEE0F12),
              fontSize: 10,
              fontFamily: 'Pretendard Variable',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.15,
            ),
          ),
        ],
      ],
    );
  }

  // 에러 메시지를 표시하는 메서드
  Widget _buildErrorText(String error) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Align(
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
      ),
    );
  }

  // 목표 선택 위젯을 생성하는 메서드
  Widget _buildGoalSelection(TodoInputViewModel viewModel, BuildContext context) {
    final goalViewModel = Provider.of<GoalViewModel>(context);
    return GoalListDropdown(
      selectedGoalId: viewModel.selectedGoalId,
      goals: goalViewModel.goals,
      isDropdownOpen: viewModel.showGoalDropdown,
      onGoalSelected: (goalId) {
        viewModel.selectGoal(goalId);
      },
      toggleDropdown: viewModel.toggleGoalDropdown,
    );
  }

  // 날짜 입력 필드를 생성하는 메서드
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
        const SizedBox(height: 24),
      ],
    );
  }

  // 아이젠하워 매트릭스를 생성하는 메서드
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
              onTap: () {
                viewModel.setEisenhower(index);
              },
            );
          }),
        ),
      ],
    );
  }
}