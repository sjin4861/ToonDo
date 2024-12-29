// lib/views/goal/goal_management_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/goal/goal_management_viewmodel.dart';
import '../../services/goal_service.dart';
import '../../models/goal.dart';
import '../goal/goal_input_screen.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/goal/goal_list_item.dart';
import '../../widgets/bottom_button/custom_button.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_input_viewmodel.dart';
import 'package:todo_with_alarm/widgets/goal/goal_options_bottom_sheet.dart';

class GoalManagementScreen extends StatelessWidget {
  const GoalManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GoalManagementViewModel>(
      create: (context) => GoalManagementViewModel(
        Provider.of<GoalService>(context, listen: false),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFCFCFC),
        appBar: CustomAppBar(
          title: '목표',
        ),
        body: Consumer<GoalManagementViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "목표 관리하기" 텍스트
                    Text(
                      '목표 관리하기',
                      style: TextStyle(
                        color: Color(0xFF111111),
                        fontSize: 20,
                        fontFamily: 'Pretendard Variable',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.24,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 필터 버튼 (전체 / 완료)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FilterButton(
                          label: '전체',
                          isSelected: viewModel.filter == '전체',
                          onTap: () {
                            viewModel.setFilter('전체');
                          },
                        ),
                        const SizedBox(width: 16),
                        FilterButton(
                          label: '완료',
                          isSelected: viewModel.filter == '완료',
                          onTap: () {
                            viewModel.setFilter('완료');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 목표 리스트
                    viewModel.filteredGoals.isEmpty
                        ? const Center(
                            child: Text(
                              '등록된 목표가 없습니다.',
                              style: TextStyle(
                                color: Color(0xFF1C1D1B),
                                fontSize: 14,
                                fontFamily: 'Pretendard Variable',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: viewModel.filteredGoals.length,
                            itemBuilder: (context, index) {
                              final goal = viewModel.filteredGoals[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
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

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: CustomButton(
            text: '목표 추가하기',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChangeNotifierProvider<GoalInputViewModel>(
                    create: (context) => GoalInputViewModel(
                      goalService:
                          Provider.of<GoalService>(context, listen: false),
                    ),
                    child: GoalInputScreen(),
                  ),
                ),
              );
            },
            backgroundColor: const Color(0xFF78B545),
            textColor: const Color(0xFFFCFCFC),
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.24,
          ),
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 163,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFF78B545) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isSelected
                  ? const Color(0xFF78B545)
                  : const Color(0xFFE4F0D9),
              width: 1,
            ),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black.withOpacity(0.5),
              fontSize: 14,
              fontFamily: 'Pretendard Variable',
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              letterSpacing: 0.21,
            ),
          ),
        ),
      ),
    );
  }
}
