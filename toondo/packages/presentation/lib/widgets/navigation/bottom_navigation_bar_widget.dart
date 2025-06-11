import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presentation/views/goal/manage/goal_manage_screen.dart';
import 'package:presentation/views/mypage/my_page_screen.dart';
import 'package:presentation/views/todo/manage/todo_manage_screen.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 68,
      color: Colors.white,
      elevation: 2.0,
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // (1) AI 분석
            _buildNavButton(
              context,
              iconPath: Assets.icons.icAiAnalysis.path,
              onTap: () {
                // TODO: 추후 AI 분석 화면으로 이동
                // MaterialPageRoute(builder: (_) => const GoalManageView()),
              },
            ),

            // (2) 투두리스트
            _buildNavButton(
              context,
              iconPath: Assets.icons.icCalendar.path,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TodoManageScreen()),
                );
              },
            ),

            // (3) 목표 관리
            _buildNavButton(
              context,
              iconPath: Assets.icons.icGoal.path,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => GoalManageScreen()),
                );
              },
            ),

            // (4) 마이페이지
            _buildNavButton(
              context,
              iconPath: Assets.icons.icMypage.path,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyPageScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 아이콘 + 텍스트로 구성된 네비게이션 버튼을 빌드
  Widget _buildNavButton(
    BuildContext context, {
    required String iconPath,
    String? label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 아이콘
            SvgPicture.asset(
              iconPath,
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(Color(0xff7F7F7F), BlendMode.srcIn),
            ),
            // label이 null이 아닐 경우에만 텍스트 표시
            if (label != null)
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
