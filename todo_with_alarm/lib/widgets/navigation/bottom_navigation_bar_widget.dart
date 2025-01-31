import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_with_alarm/views/goal/goal_management_screen.dart';
import 'package:todo_with_alarm/views/goal/goal_progress_screen.dart';
import 'package:todo_with_alarm/views/my_page/my_page_screen.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      color: Colors.white,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // (1) 목표 관리
            _buildNavButton(
              context,
              iconPath: 'assets/icons/goal.svg',
              label: '목표 관리',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GoalManagementScreen()),
                );
              },
            ),

            // (2) 목표 분석
            _buildNavButton(
              context,
              iconPath: 'assets/icons/stats.svg',
              label: '목표 분석',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => GoalProgressScreen()),
                );
              },
            ),

            const SizedBox(width: 48), // FloatingActionButton 중간 위치

            // (3) 상점 (임시 아이콘: eisenhower.svg 등)
            _buildNavButton(
              context,
              iconPath: 'assets/icons/eisenhower.svg',
              label: '상점',
              onTap: () {
                // TODO: 추후 상점 화면으로 이동
                // Navigator.push(context, MaterialPageRoute(builder: (_) => ShopScreen()));
              },
            ),

            // (4) 마이페이지
            _buildNavButton(
              context,
              iconPath: 'assets/icons/mypage.svg',
              label: '마이페이지',
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
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 60, // 원하는 너비
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 아이콘
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              color: Colors.grey,
            ),
            const SizedBox(height: 2),
            // 텍스트 라벨
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}