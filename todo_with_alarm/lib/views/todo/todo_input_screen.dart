import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SVG 아이콘 사용을 위해 추가
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/models/todo.dart';
import 'package:todo_with_alarm/providers/goal_provider.dart';
import 'package:todo_with_alarm/viewmodels/todo/todo_input_viewmodel.dart';
import 'package:todo_with_alarm/widgets/calendar_bottom_sheet.dart';

class TodoInputScreen extends StatelessWidget {
  final bool isDDayTodo;
  final Todo? todo;

  const TodoInputScreen({Key? key, this.isDDayTodo = true, this.todo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoInputViewModel>(
      create: (_) =>
          TodoInputViewModel(todo: todo, isDDayTodo: isDDayTodo),
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
            final goalProvider = Provider.of<GoalProvider>(context);

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
                            side: BorderSide(
                              width: 1,
                              color: viewModel.isTitleNotEmpty
                                  ? Color(0xFF78B545)
                                  : Color(0xFFDDDDDD),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: TextFormField(
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
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              width: 1,
                              color: viewModel.selectedGoalId != null
                                  ? Color(0xFF78B545)
                                  : Color(0xFFDDDDDD),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                viewModel.selectedGoalId != null
                                    ? goalProvider.goals
                                        .firstWhere((goal) =>
                                            goal.id ==
                                            viewModel.selectedGoalId)
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
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Color(0xFFDDDDDD)),
                          ),
                          child: Column(
                            children: [
                              _buildGoalItem(context, '목표 미설정', null, viewModel),
                              ...goalProvider.goals.map((goal) {
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '시작일',
                                    style: TextStyle(
                                      color: Color(0xFF1C1D1B),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.15,
                                      fontFamily: 'Pretendard Variable',
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () => viewModel.selectDate(
                                        context, isStartDate: true),
                                    child: Container(
                                      height: 32,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12),
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: 1,
                                              color: Color(0xFFDDDDDD)),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.calendar_today,
                                              size: 15,
                                              color: Color(0xFFDDDDDD)),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              viewModel.startDate != null
                                                  ? viewModel.dateFormat
                                                      .format(
                                                          viewModel.startDate!)
                                                  : '시작일을 선택하세요',
                                              style: TextStyle(
                                                color: viewModel.startDate !=
                                                        null
                                                    ? Color(0xFF1C1D1B)
                                                    : Color(0x3F1C1D1B),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.15,
                                                fontFamily:
                                                    'Pretendard Variable',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '마감일',
                                    style: TextStyle(
                                      color: Color(0xFF1C1D1B),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.15,
                                      fontFamily: 'Pretendard Variable',
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () => viewModel.selectDate(
                                        context, isStartDate: false),
                                    child: Container(
                                      height: 32,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12),
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: 1,
                                              color: Color(0xFFDDDDDD)),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.calendar_today,
                                              size: 15,
                                              color: Color(0xFFDDDDDD)),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              viewModel.endDate != null
                                                  ? viewModel.dateFormat
                                                      .format(
                                                          viewModel.endDate!)
                                                  : '마감일을 선택하세요',
                                              style: TextStyle(
                                                color: viewModel.endDate !=
                                                        null
                                                    ? Color(0xFF1C1D1B)
                                                    : Color(0x3F1C1D1B),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.15,
                                                fontFamily:
                                                    'Pretendard Variable',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                            children: List.generate(4, (index) {
                              return GestureDetector(
                                onTap: () {
                                  viewModel.setEisenhower(index);
                                },
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/face$index.svg',
                                      width: 32,
                                      height: 32,
                                      colorFilter: ColorFilter.mode(
                                        viewModel.selectedEisenhowerIndex ==
                                                index
                                            ? Colors.black
                                            : Colors.grey,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      _getEisenhowerLabel(index),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: viewModel
                                                    .selectedEisenhowerIndex ==
                                                index
                                            ? Colors.black
                                            : Colors.grey,
                                        fontSize: 8,
                                        fontFamily: 'Pretendard Variable',
                                        fontWeight: viewModel
                                                    .selectedEisenhowerIndex ==
                                                index
                                            ? FontWeight.w700
                                            : FontWeight.w400,
                                        letterSpacing: 0.12,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      // 작성하기/수정하기 버튼
                      GestureDetector(
                        onTap: () {
                          viewModel.saveTodo(context);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: ShapeDecoration(
                            color: Color(0xFF78B545),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              todo != null ? '수정하기' : '작성하기',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Pretendard Variable',
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.24,
                              ),
                            ),
                          ),
                        ),
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
                color:
                    isSelected ? Color(0x7FAED28F) : Color(0x7FDDDDDD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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

  // 아이젠하워 매트릭스 라벨 반환 메서드
  String _getEisenhowerLabel(int index) {
    switch (index) {
      case 0:
        return '중요하지도\n급하지도 않음';
      case 1:
        return '중요하지만\n급하지 않음';
      case 2:
        return '급하지만\n중요하지 않음';
      case 3:
        return '중요하고\n급함';
      default:
        return '';
    }
  }
}