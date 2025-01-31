// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/models/goal_status.dart';
import 'package:todo_with_alarm/models/user.dart';
import 'package:todo_with_alarm/services/auth_service.dart';
import 'package:todo_with_alarm/services/gpt_service.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_viewmodel.dart';
import 'package:todo_with_alarm/views/goal/goal_management_screen.dart';
import 'package:todo_with_alarm/views/my_page/my_page_screen.dart';
import 'package:todo_with_alarm/widgets/character/slime_area.dart';
import 'package:todo_with_alarm/widgets/goal/goal_list_section.dart';
import 'package:todo_with_alarm/widgets/character/background.dart';
import 'package:todo_with_alarm/widgets/navigation/bottom_navigation_bar_widget.dart';
import '../goal/goal_input_screen.dart';
import '../goal/goal_progress_screen.dart';
import '../todo/todo_submission_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final goalVM = Provider.of<GoalViewModel>(context, listen: false);
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
                    userNickname: userNickname,
                    gptService: gptService,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // FAB
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TodoSubmissionScreen()),
          );
        },
        child: Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(8),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.5, color: Color(0x3F1B1C1B)),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/plus.svg',
              width: 20,
              height: 20,
              color: Colors.blueAccent,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNavigationBarWidget(),
    );
  }
}