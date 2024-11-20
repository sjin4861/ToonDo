// views/goal/goal_input_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_input_viewmodel.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_viewmodel.dart';
import 'package:todo_with_alarm/widgets/calendar_bottom_sheet.dart';
import 'package:todo_with_alarm/widgets/goal_icon_bottom_sheet.dart';

class GoalInputScreen extends StatelessWidget {
  final Goal? targetGoal;

  GoalInputScreen({Key? key, this.targetGoal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GoalInputViewModel>(
      create: (_) => GoalInputViewModel(targetGoal: targetGoal),
      child: Scaffold(
        backgroundColor: Color(0xFFFCFCFC),
        appBar: AppBar(
          backgroundColor: Color(0xFFFCFCFC),
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF1C1D1B)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            '시작하기',
            style: TextStyle(
              color: Color(0xFF1C1D1B),
              fontSize: 16,
              fontFamily: 'Pretendard Variable',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.24,
            ),
          ),
          centerTitle: false,
        ),
        body: Consumer<GoalInputViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 상단 안내 문구
                    Text(
                      '목표를 정해 볼까요?',
                      style: TextStyle(
                        color: Color(0xFF78B545),
                        fontSize: 16,
                        fontFamily: 'Pretendard Variable',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.24,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '앞으로 툰두와 함께 달려 나갈 목표를 알려주세요.',
                      style: TextStyle(
                        color: Color(0xBF1C1D1B),
                        fontSize: 10,
                        fontFamily: 'Pretendard Variable',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.15,
                      ),
                    ),
                    SizedBox(height: 32),
                    // 목표 이름 입력 필드
                    Text(
                      '목표 이름',
                      style: TextStyle(
                        color: Color(0xFF1C1D1B),
                        fontSize: 10,
                        fontFamily: 'Pretendard Variable',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.15,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        // 아이콘 선택 버튼
                        GestureDetector(
                          onTap: () async {
                            String? selectedIcon = await showModalBottomSheet<String>(
                              context: context,
                              builder: (context) => GoalIconBottomSheet(),
                            );
                            if (selectedIcon != null) {
                              viewModel.selectIcon(selectedIcon);
                            }
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(4),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFDDDDDD)),
                                borderRadius: BorderRadius.circular(1000),
                              ),
                            ),
                            child: viewModel.selectedIcon != null
                                ? Image.asset(
                                    viewModel.selectedIcon!,
                                    width: 24,
                                    height: 24,
                                  )
                                : Icon(Icons.add, size: 24, color: Color(0xFFDDDDDD)),
                          ),
                        ),
                        SizedBox(width: 8),
                        // 목표 이름 입력 필드
                        Expanded(
                          child: TextField(
                            controller: viewModel.goalNameController,
                            decoration: InputDecoration(
                              hintText: '목표 이름을 입력해주세요.',
                              contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1000),
                                borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                              ),
                              errorText: viewModel.goalNameError,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (viewModel.goalNameError != null) ...[
                      SizedBox(height: 4),
                      Text(
                        viewModel.goalNameError!,
                        style: TextStyle(
                          color: Color(0xFFEE0F12),
                          fontSize: 10,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.15,
                        ),
                      ),
                    ],
                    SizedBox(height: 32),
                    // 시작일과 마감일 선택
                    Row(
                      children: [
                        // 시작일 선택
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '시작일',
                                style: TextStyle(
                                  color: Color(0xFF1C1D1B),
                                  fontSize: 10,
                                  fontFamily: 'Pretendard Variable',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.15,
                                ),
                              ),
                              SizedBox(height: 8),
                              GestureDetector(
                                onTap: () async {
                                  DateTime? pickedDate = await showModalBottomSheet<DateTime>(
                                    context: context,
                                    builder: (context) => SelectDateBottomSheet(
                                      initialDate: viewModel.startDate ?? DateTime.now(),
                                    ),
                                  );
                                  if (pickedDate != null) {
                                    viewModel.selectStartDate(pickedDate);
                                  }
                                },
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 1, color: Color(0xFFDDDDDD)),
                                      borderRadius: BorderRadius.circular(1000),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today, size: 16, color: Color(0xFFDDDDDD)),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          viewModel.startDate != null
                                              ? '${viewModel.startDate!.year}년 ${viewModel.startDate!.month}월 ${viewModel.startDate!.day}일'
                                              : '시작일을 선택하세요',
                                          style: TextStyle(
                                            color: viewModel.startDate != null ? Color(0xFF1C1D1B) : Color(0x3F1C1D1B),
                                            fontSize: 10,
                                            fontFamily: 'Pretendard Variable',
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 0.15,
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
                        // 마감일 선택
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '마감일',
                                style: TextStyle(
                                  color: Color(0xFF1C1D1B),
                                  fontSize: 10,
                                  fontFamily: 'Pretendard Variable',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.15,
                                ),
                              ),
                              SizedBox(height: 8),
                              GestureDetector(
                                onTap: () async {
                                  DateTime? pickedDate = await showModalBottomSheet<DateTime>(
                                    context: context,
                                    builder: (context) => SelectDateBottomSheet(
                                      initialDate: viewModel.endDate ?? DateTime.now(),
                                    ),
                                  );
                                  if (pickedDate != null) {
                                    viewModel.selectEndDate(pickedDate);
                                  }
                                },
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1,
                                        color: viewModel.endDate != null ? Color(0xFF78B545) : Color(0xFFDDDDDD),
                                      ),
                                      borderRadius: BorderRadius.circular(1000),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today, size: 16, color: Color(0xFFDDDDDD)),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          viewModel.endDate != null
                                              ? '${viewModel.endDate!.year}년 ${viewModel.endDate!.month}월 ${viewModel.endDate!.day}일'
                                              : '마감일을 선택하세요',
                                          style: TextStyle(
                                            color: viewModel.endDate != null ? Color(0xFF1C1D1B) : Color(0x3F1C1D1B),
                                            fontSize: 10,
                                            fontFamily: 'Pretendard Variable',
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 0.15,
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
                    if (viewModel.dateError != null) ...[
                      SizedBox(height: 4),
                      Text(
                        viewModel.dateError!,
                        style: TextStyle(
                          color: Color(0xFFEE0F12),
                          fontSize: 10,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.15,
                        ),
                      ),
                    ],
                    SizedBox(height: 32),
                    // TIP 문구
                    Row(
                      children: [
                        Text(
                          'TIP',
                          style: TextStyle(
                            color: Color(0xFF78B545),
                            fontSize: 10,
                            fontFamily: 'Pretendard Variable',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.15,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '결과를 측정할 수 있고 달성이 가능한 목표를 세워보세요!',
                            style: TextStyle(
                              color: Color(0xBF1C1D1B),
                              fontSize: 10,
                              fontFamily: 'Pretendard Variable',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    // 버튼들
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFEEEEEE),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1000),
                              ),
                              padding: EdgeInsets.all(16),
                            ),
                            child: Text(
                              '뒤로',
                              style: TextStyle(
                                color: Color(0x7F1C1D1B),
                                fontSize: 14,
                                fontFamily: 'Pretendard Variable',
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.21,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () => _setGoal(context, viewModel),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF78B545),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1000),
                              ),
                              padding: EdgeInsets.all(16),
                            ),
                            child: Text(
                              '다음으로',
                              style: TextStyle(
                                color: Color(0xFFFCFCFC),
                                fontSize: 14,
                                fontFamily: 'Pretendard Variable',
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.21,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),  
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _setGoal(BuildContext context, GoalInputViewModel viewModel) async {
    viewModel.saveGoal();
    final goalViewmodel = Provider.of<GoalViewModel>(context, listen: false);
    if (viewModel.targetGoal != null) {
      await goalViewmodel.updateGoal(viewModel.targetGoal!);
    } else {
      await goalViewmodel.addGoal(viewModel.targetGoal!);
    }
    Navigator.pop(context);
  }
}