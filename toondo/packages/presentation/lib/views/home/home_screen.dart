// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../../packages/data/lib/models/goal.dart';
import '../../../packages/data/lib/models/goal_status.dart';
import '../../../packages/data/lib/models/user.dart';
import 'package:toondo/services/auth_service.dart';
import 'package:toondo/services/gpt_service.dart';
import 'package:toondo/viewmodels/character/slime_character_viewmodel.dart';
import 'package:toondo/viewmodels/goal/goal_viewmodel.dart';
import 'package:toondo/views/goal/goal_management_screen.dart';
import 'package:toondo/views/my_page/my_page_screen.dart';
import '../../../packages/presentaion/lib/widgets/bottom_button/expandable_floating_button.dart';
import '../../../packages/presentaion/lib/widgets/character/slime_area.dart';
import '../../../packages/presentaion/lib/widgets/goal/goal_list_section.dart';
import '../../../packages/presentaion/lib/widgets/character/background.dart';
import '../../../packages/presentaion/lib/widgets/navigation/bottom_navigation_bar_widget.dart';
import '../goal/goal_input_screen.dart';
import '../goal/goal_progress_screen.dart';
import '../todo/todo_submission_screen.dart';
import 'dart:math';
import 'package:toondo/services/data_sync_service.dart';
import 'package:presentation/widgets/data_sync_initializer.dart';

class HomeScreen extends StatelessWidget {
  final bool isNewLogin;
  const HomeScreen({Key? key, this.isNewLogin = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final goalVM = Provider.of<GoalViewModel>(context);
    final userBox = Hive.box<User>('user');
    final currentUser = userBox.get('currentUser');
    final String userNickname = currentUser?.username ?? 'null';

    // 진행 중 목표만 필터 → 종료일 오름차순 → 상위 3개
    final inProgressGoals = goalVM.goals
        .where((g) => g.status == GoalStatus.active)
        .toList();
    inProgressGoals.sort((a, b) => a.endDate.compareTo(b.endDate));
    final top3Goals = inProgressGoals.take(3).toList();

    final gptService = Provider.of<GptService>(context, listen: false);

    // Provider로 슬라임 ViewModel을 하위 위젯에 공급
    return ChangeNotifierProvider<SlimeCharacterViewModel>(
      create: (_) => SlimeCharacterViewModel(),
      child: Builder(builder: (context) {
        final slimeVM = Provider.of<SlimeCharacterViewModel>(context);
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
                    await AuthService().logout();
                    Navigator.pushReplacementNamed(context, '/');
                  }
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              // DataSyncInitializer는 isNewLogin일 때 동기화 호출
              DataSyncInitializer(isNewLogin: isNewLogin),
              // 1) 배경
              const HomeBackground(),

              // 2) SafeArea + Column(목표 리스트 + 슬라임 영역)
              SafeArea(
                child: Column(
                  children: [
                    // 상단 목표 리스트
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal:16, vertical: 8),
                        child: GoalListSection(topGoals: top3Goals),
                      ),
                    ),
                    // 하단 슬라임 영역
                    Expanded(
                      flex: 3,
                      child: SlimeArea(
                        characterViewModel: slimeVM,
                        userNickname: userNickname,
                        gptService: gptService,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: const ExpandableFab(),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: const BottomNavigationBarWidget(),
        );
      }),
    );
  }
}