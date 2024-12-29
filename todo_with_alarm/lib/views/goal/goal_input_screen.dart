// lib/views/goal/goal_input_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/services/goal_service.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_input_viewmodel.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_viewmodel.dart';
import 'package:todo_with_alarm/widgets/app_bar/custom_app_bar.dart';
import 'package:todo_with_alarm/widgets/bottom_button/custom_button.dart';
import 'package:todo_with_alarm/widgets/calendar/calendar_bottom_sheet.dart';
import 'package:todo_with_alarm/widgets/goal/goal_icon_bottom_sheet.dart';
import 'package:todo_with_alarm/widgets/text_fields/goal_name_input_field.dart';
import 'package:todo_with_alarm/widgets/goal/goal_input_date_field.dart';
import 'package:todo_with_alarm/widgets/text_fields/tip.dart';
import 'package:todo_with_alarm/widgets/goal/goal_setting_bottom_sheet.dart';
class GoalInputScreen extends StatelessWidget {
  final Goal? targetGoal;

  GoalInputScreen({Key? key, this.targetGoal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      appBar: CustomAppBar(
        title: '목표 설정하기',
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
                    TipWidget(
                      title: 'TIP',
                      description: '결과를 측정할 수 있고 달성이 가능한 목표를 세워보세요!',
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        ),
        // 작성하기 버튼을 Scaffold의 bottomNavigationBar에 배치
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: CustomButton(
            text: '작성하기',
            onPressed: () => _setGoal(context),
            backgroundColor: const Color(0xFF78B545),
            textColor: const Color(0xFFFCFCFC),
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.24,
            padding: 16.0,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );
    }
  void _setGoal(BuildContext context) async {
    final viewModel = Provider.of<GoalInputViewModel>(context, listen: false);
    Goal? newGoal= await viewModel.saveGoal(context);
    if (newGoal != null) {
      // 목표 저장 성공 시 BottomSheet 표시
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => GoalSettingBottomSheet(goal: newGoal),
      );
    }
  } 
}
