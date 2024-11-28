// lib/views/goal/goal_input_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/services/goal_service.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_input_viewmodel.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_viewmodel.dart';
import 'package:todo_with_alarm/widgets/calendar/calendar_bottom_sheet.dart';
import 'package:todo_with_alarm/widgets/goal/goal_icon_bottom_sheet.dart';
import 'package:todo_with_alarm/widgets/text_fields/goal_name_input_field.dart';
import 'package:todo_with_alarm/widgets/goal/goal_input_date_field.dart';
class GoalInputScreen extends StatelessWidget {
  final Goal? targetGoal;

  GoalInputScreen({Key? key, this.targetGoal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GoalInputViewModel>(
      create: (context) => GoalInputViewModel(
        goalService: Provider.of<GoalService>(context, listen: false),
        targetGoal: targetGoal,
      ),
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
                    GoalNameInputField(
                      controller: viewModel.goalNameController,
                      errorText: viewModel.goalNameError,
                    ),
                    SizedBox(height: 32),
                    // 시작일과 마감일 선택
                    Row(
                      children: [
                        // 시작일 선택
                        Expanded(
                          child: GoalInputDateField(
                            viewModel: viewModel,
                            label: '시작일',
                          ),
                        ),
                        SizedBox(width: 16),
                        // 마감일 선택
                        Expanded(
                          child: GoalInputDateField(
                            viewModel: viewModel,
                            label: '마감일',
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
    bool isSaved = await viewModel.saveGoal(context);
    if (isSaved) {
      Navigator.pop(context);
    }
  }  
}
