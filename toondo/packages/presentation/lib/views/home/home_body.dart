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

    final inProgressGoals = homeVM.goals
        .where((g) => g.status == Status.active)
        .toList()
      ..sort((a, b) => a.endDate.compareTo(b.endDate));
    final top3Goals = inProgressGoals.take(3).toList();

    return Stack(
      children: [
        const HomeBackground(),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
          child: Column(
              children: [
                Expanded(child: HomeGoalListSection(goals: top3Goals)),
              ],
            ),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: FractionalTranslation(
            translation: const Offset(0, -0.18),
            child: const SlimeArea(),
          ),
        ),

        Positioned(
          bottom: 120,
          left: 10,
          child: Assets.images.imgBackgroundFlowers.svg(),
        ),
      ],
    );

  }

}
