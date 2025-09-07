import 'package:flutter/material.dart';
import 'package:presentation/designsystem/components/character/slime_area.dart';
import 'package:presentation/designsystem/components/menu/app_selectable_menu_bar.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/viewmodels/home/home_viewmodel.dart';
import 'package:presentation/views/home/widget/home_goal_list_section.dart';
import 'package:presentation/views/home/widget/home_todo_list_section.dart';
import 'package:presentation/views/home/widget/home_background.dart';
import 'package:provider/provider.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final homeVM = context.watch<HomeViewModel>();

    return RefreshIndicator(
      onRefresh: () async {
        await homeVM.refresh();
      },
      child: Stack(
        children: [
          const HomeBackground(),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.h18,
              vertical: AppSpacing.v24,
            ),
            child: Column(
              children: [
                AppSelectableMenuBar(
                  labels: ['투두', '목표'],
                  selectedIndex: homeVM.selectedTabIndex,
                  onChanged: homeVM.changeTab,
                ),
                SizedBox(height: AppSpacing.v24),
                Expanded(
                  child: homeVM.selectedTabIndex == 0
                      ? HomeTodoListSection(todos: homeVM.todayTop3Todos)
                      : HomeGoalListSection(goals: homeVM.todayTop3Goals),
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: FractionalTranslation(
              translation: const Offset(0, -0.22),
              child: const SlimeArea(),
            ),
          ),
        ],
      ),
    );
  }
}
