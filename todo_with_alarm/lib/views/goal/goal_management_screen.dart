// lib/views/goal/goal_management_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/data/models/goal_status.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_filter_option.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_management_viewmodel.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_viewmodel.dart';
import 'package:todo_with_alarm/widgets/top_menu_bar/menu_bar2.dart';
import '../../services/goal_service.dart';
import '../../data/models/goal.dart';
import '../goal/goal_input_screen.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/goal/goal_list_item.dart';
import '../../widgets/bottom_button/custom_button.dart';
import 'package:todo_with_alarm/widgets/goal/goal_options_bottom_sheet.dart';

class GoalManagementScreen extends StatelessWidget {
  const GoalManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final managementVM = Provider.of<GoalManagementViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      appBar: CustomAppBar(title: '목표'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '목표 관리하기',
                style: TextStyle(
                  color: Color(0xFF111111),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.24,
                ),
              ),
              const SizedBox(height: 16),

              TwoMenuBarWidget(
                selectedOption: managementVM.filterOption,
                onOptionSelected: (option) => managementVM.setFilterOption(option),
              ),
              const SizedBox(height: 24),

              managementVM.filteredGoals.isEmpty
                  ? const Center(child: Text('등록된 목표가 없습니다.'))
                  : _buildGoalListSection(context, managementVM),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: CustomButton(
          text: '목표 추가하기',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GoalInputScreen()),
            );
          },
          backgroundColor: const Color(0xFF78B545),
          textColor: const Color(0xFFFCFCFC),
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.24,
        ),
      ),
    );
  }
  /// 진행 중이면 '미완료' 목표 목록, 진행 완료면 '완료 or 포기' 목록을 보여주는 메서드
  Widget _buildGoalListSection(BuildContext context, GoalManagementViewModel viewModel) {
    /// filteredGoals에는 이미 goalVM에서 필터링된 목록 (inProgress or completed)
    final goals = viewModel.filteredGoals;

    /// !!! 여기서 GoalStatus가 아니라 GoalFilterOption과 비교해야 함
    if (viewModel.filterOption == GoalFilterOption.completed) {
      /// '진행 완료' 필터일 때, 내부적으로 '완료' / '포기'를 구분하여 섹션화
      List<Goal> completedGoals = goals.where((g) => g.status == GoalStatus.completed).toList();
      List<Goal> givenUpGoals = goals.where((g) => g.status == GoalStatus.givenUp).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// '성공' 섹션
          if (completedGoals.isNotEmpty) ...[
            Text(
              '성공',
              style: const TextStyle(
                color: Color(0xFF1C1D1B),
                fontSize: 16,
                fontFamily: 'Pretendard Variable',
                fontWeight: FontWeight.w600,
                letterSpacing: 0.16,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: completedGoals.length,
              itemBuilder: (context, index) {
                final goal = completedGoals[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GoalListItem(
                    goal: goal,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => GoalOptionsBottomSheet(goal: goal),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],

          /// '포기' 섹션
          if (givenUpGoals.isNotEmpty) ...[
            Text(
              '포기',
              style: const TextStyle(
                color: Color(0xFF1C1D1B),
                fontSize: 16,
                fontFamily: 'Pretendard Variable',
                fontWeight: FontWeight.w600,
                letterSpacing: 0.16,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: givenUpGoals.length,
              itemBuilder: (context, index) {
                final goal = givenUpGoals[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GoalListItem(
                    goal: goal,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => GoalOptionsBottomSheet(goal: goal),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ],
      );
    } else {
      /// GoalFilterOption.inProgress → 그냥 리스트 보여주기
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: goals.length,
        itemBuilder: (context, index) {
          final goal = goals[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GoalListItem(
              goal: goal,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => GoalOptionsBottomSheet(goal: goal),
                );
              },
            ),
          );
        },
      );
    }
  }
}