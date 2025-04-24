import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domain/entities/status.dart';
import 'package:presentation/widgets/bottom_button/expandable_floating_button.dart';
import 'package:presentation/widgets/character/background.dart';
import 'package:presentation/widgets/goal/goal_list_section.dart';
import 'package:presentation/widgets/navigation/bottom_navigation_bar_widget.dart';
import 'package:presentation/widgets/character/slime_area.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/home/home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  final bool isNewLogin;
  const HomeScreen({Key? key, this.isNewLogin = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>.value(
      value: GetIt.instance<HomeViewModel>(),
      child: Consumer<HomeViewModel>(
        builder: (context, homeVM, child) {
          // homeVM에서 사용자 닉네임과 목표 리스트 직접 사용
          final String userNickname = homeVM.userNickname;
          final inProgressGoals = homeVM.goals
              .where((g) => g.status == Status.active)
              .toList();
          inProgressGoals.sort((a, b) => a.endDate.compareTo(b.endDate));
          final top3Goals = inProgressGoals.take(3).toList();
          
          return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('ToonDo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  key: const Key('logoutButton'),
                  icon: const Icon(Icons.exit_to_app, size: 24),
                  onPressed: () async {
                    final shouldLogout = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('로그아웃'),
                        content: const Text('정말 로그아웃 하시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('취소'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('로그아웃'),
                          ),
                        ],
                      ),
                    );
                    if (shouldLogout == true) {
                      await homeVM.logout();
                      Navigator.pushReplacementNamed(context, '/');
                    }
                  },
                ),
              ],
            ),
            body: Stack(
              children: [
                // 배경
                const HomeBackground(),
                // SafeArea 내 주요 콘텐츠
                SafeArea(
                  child: Column(
                    children: [
                      // 상단 목표 리스트 섹션
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: GoalListSection(topGoals: top3Goals),
                        ),
                      ),
                      // 하단 슬라임 캐릭터 영역
                      Expanded(
                        flex: 3,
                        child: SlimeArea(
                          userNickname: userNickname,
                          getSlimeResponseUseCase: homeVM.getSlimeResponseUseCase,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: const BottomNavigationBarWidget(),
          );
        },
      ),
    );
  }
}