import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/goal/goal_management_viewmodel.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/goal/goal_list_item.dart';
import 'package:presentation/views/goal/goal_input_view.dart';
import 'package:presentation/widgets/top_menu_bar/menu_bar2.dart';
import 'package:presentation/widgets/bottom_button/custom_button.dart';
import 'package:presentation/widgets/goal/goal_options_bottom_sheet.dart';
import 'package:domain/entities/status.dart';
class GoalManageView extends StatelessWidget {
  const GoalManageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GoalManagementViewModel>.value(
      value: GetIt.instance<GoalManagementViewModel>(),
      child: Consumer<GoalManagementViewModel>(
        builder: (context, managementVM, child) {
          return Scaffold(
            backgroundColor: const Color(0xFFFCFCFC),
            appBar: CustomAppBar(title: '목표 관리하기'),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TwoMenuBarWidget(
                      selectedStatus: managementVM.filterOption == GoalManagementFilterOption.inProgress
                          ? Status.active
                          : Status.completed, // 진행 완료가 선택된 경우 (givenUp은 메뉴에 노출하지 않음)
                      onStatusSelected: (status) {
                        managementVM.setFilterOption(
                          status == Status.active
                              ? GoalManagementFilterOption.inProgress
                              : GoalManagementFilterOption.completed,
                        );
                      },
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
                    MaterialPageRoute(
                      builder: (context) => const GoalInputView(),
                    ),
                  ).then((_) {
                    // 새 목표 작성 후 즉시 갱신
                    Provider.of<GoalManagementViewModel>(context, listen: false)
                        .loadGoals();
                  });
                },
                backgroundColor: const Color(0xFF78B545),
                textColor: const Color(0xFFFCFCFC),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.24,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGoalListSection(
      BuildContext context, GoalManagementViewModel viewModel) {
    if (viewModel.filterOption == GoalManagementFilterOption.completed) {
      final completedGoals = viewModel.getCompletedGoals();
      final givenUpGoals = viewModel.getGivenUpGoals();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (completedGoals.isNotEmpty) ...[
            const Text(
              '성공',
              style: TextStyle(
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
                        builder: (context) =>
                            GoalOptionsBottomSheet(goal: goal),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
          if (givenUpGoals.isNotEmpty) ...[
            const Text(
              '포기',
              style: TextStyle(
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
                        builder: (context) =>
                            GoalOptionsBottomSheet(goal: goal),
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
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: viewModel.filteredGoals.length,
        itemBuilder: (context, index) {
          final goal = viewModel.filteredGoals[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GoalListItem(
              goal: goal,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) =>
                      GoalOptionsBottomSheet(goal: goal),
                );
              },
            ),
          );
        },
      );
    }
  }
}
