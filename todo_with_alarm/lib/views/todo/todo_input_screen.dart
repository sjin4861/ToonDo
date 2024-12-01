// lib/views/todo/todo_input_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/services/todo_service.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_viewmodel.dart';
import 'package:todo_with_alarm/viewmodels/todo/todo_input_viewmodel.dart';
import 'package:todo_with_alarm/widgets/bottom_button/edit_update_button.dart';
import 'package:todo_with_alarm/widgets/text_fields/tip.dart';
import 'package:todo_with_alarm/widgets/todo/eisenhower_button.dart';
import 'package:todo_with_alarm/widgets/text_fields/custom_text_field.dart';
import 'package:todo_with_alarm/widgets/todo/todo_input_date_field.dart'; // 새로 추가된 위젯

class TodoInputScreen extends StatelessWidget {
  final bool isDDayTodo;
  final Todo? todo;

  const TodoInputScreen({super.key, this.isDDayTodo = true, this.todo});


  @override
  Widget build(BuildContext context) {
    final TodoService todoService = Provider.of<TodoService>(context, listen: false);

    return ChangeNotifierProvider<TodoInputViewModel>(
      create: (_) => TodoInputViewModel(todo: todo, isDDayTodo: isDDayTodo, todoService: todoService),
      child: Scaffold(
        backgroundColor: Color(0xFFFCFCFC),
        appBar: AppBar(
          backgroundColor: Color(0xFFFCFCFC),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF1C1D1B)),
            onPressed: () {
              Navigator.pop(context); // 이전 페이지로 이동
            },
          ),
          title: Text(
            todo != null ? '투두 수정' : '투두 작성',
            style: TextStyle(
              color: Color(0xFF1C1D1B),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.24,
              fontFamily: 'Pretendard Variable',
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0.5),
            child: Container(
              color: Color(0x3F1C1D1B),
              height: 0.5,
            ),
          ),
        ),
        body: Consumer<TodoInputViewModel>(
          builder: (context, viewModel, child) {
            final goalViewmodel = Provider.of<GoalViewModel>(context);
            
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: viewModel.formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      // 디데이/데일리 토글 버튼
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                viewModel.setDailyTodoStatus(false);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 8),
                                decoration: ShapeDecoration(
                                  color: !viewModel.isDailyTodo
                                      ? Color(0xFF78B545)
                                      : Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1, color: Color(0xFF78B545)),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      bottomLeft: Radius.circular(4),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  '디데이',
                                  style: TextStyle(
                                    color: !viewModel.isDailyTodo
                                        ? Colors.white
                                        : Color(0xFF1C1D1B),
                                    fontSize: 10,
                                    fontFamily: 'Pretendard Variable',
                                    fontWeight: !viewModel.isDailyTodo
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    letterSpacing: 0.15,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                viewModel.setDailyTodoStatus(true);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 8),
                                decoration: ShapeDecoration(
                                  color: viewModel.isDailyTodo
                                      ? Color(0xFF78B545)
                                      : Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1, color: Color(0xFF78B545)),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(4),
                                      bottomRight: Radius.circular(4),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  '데일리',
                                  style: TextStyle(
                                    color: viewModel.isDailyTodo
                                        ? Colors.white
                                        : Color(0xFF1C1D1B),
                                    fontSize: 10,
                                    fontFamily: 'Pretendard Variable',
                                    fontWeight: viewModel.isDailyTodo
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                    letterSpacing: 0.15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      // 투두 이름
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '투두 이름',
                          style: TextStyle(
                            color: Color(0xFF1C1D1B),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.15,
                            fontFamily: 'Pretendard Variable',
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1000),
                            side: BorderSide(
                              width: 1,
                              color: viewModel.isTitleNotEmpty
                                  ? Color(0xFF78B545) // 초록색 테두리
                                  : Color(0xFFDDDDDD), // 기본 회색 테두리
                            ),
                          ),
                        ),
                        child: TextFormField(
                          key: Key('todoTitleField'),
                          controller: viewModel.titleController,
                          maxLength: 20,
                          decoration: InputDecoration(
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
                          style: TextStyle(
                            color: Color(0xFF1C1D1B),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.18,
                            fontFamily: 'Pretendard Variable',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '투두 이름을 입력해주세요.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            viewModel.title = value!.trim();
                          },
                        ),
                      ),
                      if (viewModel.goalNameError != null) ...[
                        SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            viewModel.goalNameError!,
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
                      SizedBox(height: 24),
                      // 목표 선택
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '목표',
                          style: TextStyle(
                            color: Color(0xFF1C1D1B),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.15,
                            fontFamily: 'Pretendard Variable',
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1000),
                            side: BorderSide(
                              width: 1,
                              color: viewModel.selectedGoalId != null
                                  ? Color(0xFF78B545) // 초록색 테두리
                                  : Color(0xFFDDDDDD), // 기본 회색 테두리
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                viewModel.selectedGoalId != null
                                    ? goalViewmodel.goals
                                        .firstWhere(
                                            (goal) => goal.id == viewModel.selectedGoalId)
                                        .name
                                    : '목표를 선택하세요.',
                                style: TextStyle(
                                  color: Color(0xFF1C1D1B),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.18,
                                  fontFamily: 'Pretendard Variable',
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                viewModel.toggleGoalDropdown();
                              },
                              child: Icon(
                                viewModel.showGoalDropdown
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: Color(0xFF1C1D1B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (viewModel.showGoalDropdown)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xFFDDDDDD)),
                          ),
                          child: Column(
                            children: [
                              _buildGoalItem(
                                  context, '목표 미설정', null, viewModel),
                              ...goalViewmodel.goals.map((goal) {
                                return _buildGoalItem(
                                    context, goal.name, goal.id, viewModel);
                              }).toList(),
                            ],
                          ),
                        ),
                      SizedBox(height: 24),
                      // 시작일 및 마감일 (데일리 투두가 아닐 때만 표시)
                      if (!viewModel.isDailyTodo)
                        Row(
                          children: [
                            DateField(viewModel: viewModel, label: "시작일"),
                            SizedBox(width: 16),
                            DateField(viewModel: viewModel, label: "마감일")
                          ],
                        ),
                      SizedBox(height: 24),
                      // 아이젠하워 매트릭스 선택
                      Column(
                        children: [
                          Text(
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
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                            children: [
                              // 각 아이젠하워 매트릭스 버튼
                              EisenhowerButton(
                                index: 0,
                                label: '중요하거나\n급하지 않아',
                                isSelected:
                                    viewModel.selectedEisenhowerIndex == 0,
                                selectedBackgroundColor: Color(0x7FE2DFDE),
                                selectedBorderColor: Color(0x7FE2DFDE),
                                selectedTextColor: Color(0xFF423B36),
                                unselectedTextColor: Color(0x7F1C1D1B),
                                iconPath: 'assets/icons/face0.svg',
                                onTap: () {
                                  viewModel.setEisenhower(0);
                                },
                              ),
                              EisenhowerButton(
                                index: 1,
                                label: '중요하지만\n급하지는 않아',
                                isSelected:
                                    viewModel.selectedEisenhowerIndex == 1,
                                selectedBackgroundColor: Color(0x7FE5F4FE),
                                selectedBorderColor: Color(0x7FE5F4FE),
                                selectedTextColor: Color(0xFF497895),
                                unselectedTextColor: Color(0x7F1C1D1B),
                                iconPath: 'assets/icons/face1.svg',
                                onTap: () {
                                  viewModel.setEisenhower(1);
                                },
                              ),
                              EisenhowerButton(
                                index: 2,
                                label: '급하지만\n중요하지 않아',
                                isSelected:
                                    viewModel.selectedEisenhowerIndex == 2,
                                selectedBackgroundColor: Color(0x7FFDF8DE),
                                selectedBorderColor: Color(0x7FFDF8DE),
                                selectedTextColor: Color(0xFF948436),
                                unselectedTextColor: Color(0x7F1C1D1B),
                                iconPath: 'assets/icons/face2.svg',
                                onTap: () {
                                  viewModel.setEisenhower(2);
                                },
                              ),
                              EisenhowerButton(
                                index: 3,
                                label: '중요하고\n급한일이야!',
                                isSelected:
                                    viewModel.selectedEisenhowerIndex == 3,
                                selectedBackgroundColor: Color(0x7FFCE9EA),
                                selectedBorderColor: Color(0x7FFCE9EA), // 테두리 색상 맞춤
                                selectedTextColor: Color(0xFF91595A), // 텍스트 색상 변경
                                unselectedTextColor: Color.fromARGB(126, 1, 1, 0),
                                iconPath: 'assets/icons/face3.svg',
                                onTap: () {
                                  viewModel.setEisenhower(3);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          TipWidget(
                            title: 'TIP',
                            description: '아이젠하워는 긴급도와 중요도에 따라 할 일을 정리하는 방법이에요.\n'
                                '앞으로 툰두가 아이젠하워에 따라 가장 중요한 일부터 알려줄게요!',
                          ),
                          SizedBox(height: 24),
                        ],
                      ),
                      // 작성하기/수정하기 버튼
                      Row(
                        children: [
                          Expanded(
                            child: EditUpdateButton(key: Key('editUpdateButton'), viewModel: viewModel, todo: todo)),
                        ],
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // 목표 아이템 위젯 생성
  Widget _buildGoalItem(BuildContext context, String goalName,
      String? goalId, TodoInputViewModel viewModel) {
    bool isSelected = viewModel.selectedGoalId == goalId;
    return GestureDetector(
      onTap: () {
        viewModel.selectGoal(goalId);
      },
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFE4F0D9) : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: Color(0xFFDDDDDD), width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: ShapeDecoration(
                color: isSelected ? Color(0x7FAED28F) : Color(0x7FDDDDDD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
              ),
              child: Center(
                child: Icon(Icons.flag, size: 16, color: Colors.white),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                goalName,
                style: TextStyle(
                  color: Color(0xFF1C1D1B),
                  fontSize: 12,
                  fontFamily: 'Pretendard Variable',
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}