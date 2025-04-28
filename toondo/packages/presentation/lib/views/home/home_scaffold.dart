import 'package:common/gen/assets.gen.dart';
import 'package:domain/entities/status.dart';
import 'package:flutter/material.dart';
import 'package:presentation/viewmodels/home/home_viewmodel.dart';
import 'package:presentation/widgets/character/slime_area.dart';
import 'package:presentation/widgets/goal/goal_list_section.dart';
import 'package:presentation/widgets/home/home_app_bar.dart';
import 'package:presentation/widgets/home/home_background.dart';
import 'package:presentation/widgets/navigation/bottom_navigation_bar_widget.dart';
import 'package:provider/provider.dart';

/// 홈 화면의 전체 레이아웃을 구성하는 Scaffold
/// (앱바, 배경, 목표 리스트, 슬라임 영역, 하단 내비게이션으로 구성)
class HomeScaffold extends StatelessWidget {
  final bool isNewLogin;
  const HomeScaffold({super.key, required this.isNewLogin});

  static const double _slimeAreaHeight = 500; // 슬라임 영역 높이

  @override
  Widget build(BuildContext context) {
    final homeVM = context.watch<HomeViewModel>();

    final inProgressGoals = homeVM.goals
        .where((g) => g.status == Status.active)
        .toList()
      ..sort((a, b) => a.endDate.compareTo(b.endDate));
    final top3Goals = inProgressGoals.take(3).toList();

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: const HomeAppBar(),
      body: Stack(
        children: [
          const HomeBackground(), // (1) 배경

          // (2) 슬라임 영역
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: _slimeAreaHeight,
              child: SlimeArea(
                userNickname: homeVM.userNickname,
                getSlimeResponseUseCase: homeVM.getSlimeResponseUseCase,
              ),
            ),
          ),

          // (3) 배경 꽃
          Positioned(
            bottom: 120,
            left: 10,
            child: Assets.images.imgBackgroundFlowers.svg(
              fit: BoxFit.cover,
            )
          ),

          // (4) 골 리스트
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: _slimeAreaHeight),
              child: GoalListSection(topGoals: top3Goals),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }
}
