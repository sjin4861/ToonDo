import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/home/home_viewmodel.dart';
import 'package:presentation/widgets/character/slime_area.dart';
import 'package:presentation/widgets/home/home_background.dart';
import 'package:presentation/widgets/home/home_goal_list_section.dart';
import 'package:provider/provider.dart';
import 'package:domain/entities/status.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  static const double _slimeAreaHeight = 500;

  @override
  Widget build(BuildContext context) {
    final homeVM = context.watch<HomeViewModel>();

    final inProgressGoals =
        homeVM.goals.where((g) => g.status == Status.active).toList()
          ..sort((a, b) => a.endDate.compareTo(b.endDate));
    final top3Goals = inProgressGoals.take(3).toList();

    return Stack(
      children: [
        const HomeBackground(),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SizedBox(height: _slimeAreaHeight, child: const SlimeArea()),
        ),

        Positioned(
          bottom: 120,
          left: 10,
          child: Assets.images.imgBackgroundFlowers.svg(),
        ),

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 40,
              bottom: _slimeAreaHeight + 20,
            ),
            child: HomeGoalListSection(goals: top3Goals),
          ),
        ),
      ],
    );
  }
}
