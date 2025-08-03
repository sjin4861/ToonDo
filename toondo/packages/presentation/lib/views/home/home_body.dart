import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:presentation/designsystem/menu/app_selectable_menu_bar.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/viewmodels/home/home_viewmodel.dart';
import 'package:presentation/views/home/widget/home_goal_list_section.dart';
import 'package:presentation/views/home/widget/home_todo_list_section.dart';
import 'package:presentation/widgets/character/slime_area.dart';
import 'package:presentation/views/home/widget/home_background.dart';
import 'package:provider/provider.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final homeVM = context.watch<HomeViewModel>();

    return Stack(
      children: [
        const HomeBackground(),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacing18,
            vertical: AppSpacing.spacing24,
          ),
          child: Column(
            children: [
              AppSelectableMenuBar(
                labels: ['투두', '목표'],
                selectedIndex: homeVM.selectedTabIndex,
                onChanged: homeVM.changeTab,
              ),
              const SizedBox(height: AppSpacing.spacing24),
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
    );
  }
}
