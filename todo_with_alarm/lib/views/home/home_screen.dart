// lib/screens/home_screen.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/models/goal.dart';
import 'package:todo_with_alarm/viewmodels/goal/goal_viewmodel.dart';
import 'package:todo_with_alarm/views/auth/login_screen.dart';
import 'package:todo_with_alarm/views/goal/goal_management_screen.dart';
import 'package:todo_with_alarm/widgets/goal/goal_list_item.dart';
import 'package:todo_with_alarm/widgets/image_shadow.dart';
import '../goal/goal_input_screen.dart';
import '../goal/goal_progress_screen.dart';
import '../todo/todo_submission_screen.dart';
// import 'eisenhower_matrix_screen.dart';
import 'dart:math';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final goalViewmodel = Provider.of<GoalViewModel>(context);

    return Scaffold(
      extendBody: true, // Scaffold의 body가 BottomAppBar 뒤로 확장되도록 설정
      backgroundColor: Colors.transparent, // 배경 색상을 투명하게 설정
      extendBodyBehindAppBar: true, // AppBar가 배경을 덮지 않도록 설정
      appBar: AppBar(
        title: const SizedBox(
          width: 100, // 원하는 너비 지정
          height: 40, // 원하는 높이 지정
          child: Center(
            child: Text(
              'ToonDo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          SizedBox(
            width: 50, // 아이콘 버튼의 너비 지정
            height: 50, // 아이콘 버튼의 높이 지정
            child: IconButton(
              key: const Key('goToLoginButton'),
              icon: const Icon(Icons.login, size: 24),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 배경 그라데이션
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xFFFDF8EB), Color(0xFFE2F1F6)],
                ),
              ),
            ),
          ),
          // SafeArea를 Stack 내에 배치하여 시스템 UI와 겹치지 않도록 함
          SafeArea(
            child: Column(
              children: [
                // 목표 리스트 상단 배치
                Expanded(
                  flex: 4, // 화면의 40%를 목표 리스트에 할당
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: goalViewmodel.goals.isNotEmpty
                        ? Column(
                            children: goalViewmodel.goals.take(3).map((goal) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: GoalListItem(
                                  goal: goal,
                                  onTap: () {
                                    // 아무 동작도 하지 않도록 설정, 추후에는 캐릭터와 상호작용하도록 해야할 듯
                                  },
                                ),
                              );
                            }).toList(),
                          )
                        : const Center(
                            child: Text(
                              '설정된 목표가 없습니다. 목표를 추가해보세요!',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                  ),
                ),
                // 캐릭터 이미지와 말풍선 배치
                Expanded(
                  flex: 3, // 화면의 30%를 캐릭터와 말풍선에 할당
                  child: Stack(
                    children: [
                      // 왼쪽 수풀 이미지
                      Positioned(
                        left: 0,
                        bottom: 20,
                        child: SvgPicture.asset(
                          'assets/icons/group-2.svg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      // 오른쪽 수풀 이미지
                      Positioned(
                        right: 0,
                        bottom: 20,
                        child: SvgPicture.asset(
                          'assets/icons/group-3.svg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      // 갈색 배경
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: double.infinity,
                          height: 110, // 원하는 높이로 설정
                          color: const Color(0xFFECDFBB), // 갈색 배경색 (#ECDFBB)
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(3, (index) {
                              //선 2개 생성
                              return Container(
                                width: double.infinity,
                                height: 2, // 선의 두께
                                color: const Color.fromARGB(
                                    255, 248, 238, 226), // 선의 색상
                              );
                            }),
                          ),
                        ),
                      ),
                      // 메인 캐릭터 이미지
                      Positioned(
                        left: MediaQuery.of(context).size.width / 2 -
                            75, // 화면 중앙에 위치
                        bottom: 80, // 갈색 배경 위에 위치하도록 설정
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: ImageShadow(
                            opacity: 0.2, // 그림자 투명도
                            sigma: 7, // 블러 정도
                            color: Colors.black, // 그림자 색상
                            offset: const Offset(0, 300), // 그림자를 아래로 이동
                            transform: Matrix4.identity()
                              ..setEntry(3, 1, -0.001) // 원근감 추가
                              ..rotateX(pi / 4) // X축으로 45도 회전하여 찌그러뜨림
                              ..scale(0.7, 0.3), // 세로로 축소하여 그림자 모양 조정
                            child: SvgPicture.asset(
                              'assets/icons/character.svg', // SVG 파일 경로
                              width: 150, // SVG 파일 너비
                              height: 150, // SVG 파일 높이
                              fit: BoxFit.contain, // SVG의 적합 방식
                            ),
                          ),
                        ),
                      ),
                      // 말풍선
                      Positioned(
                        left: MediaQuery.of(context).size.width / 2 -
                            125, // 화면 중앙에 위치
                        bottom: 230, // 캐릭터 이미지 위쪽에 위치
                        child: GestureDetector(
                          onTap: () =>
                              ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('말풍선이 클릭되었습니다!')),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/speech_bubble.svg',
                                width: 200,
                                height: 45,
                              ),
                              const Text(
                                '오늘은 어떤 멋진 하루를 보낼까?',
                                style: TextStyle(
                                  color: Color(0xFF605956),
                                  fontSize: 12,
                                  fontFamily: 'Nanum Pen Script',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 갈색 배경 컨테이너 추가 (BottomAppBar 뒤에 위치)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              height: 110, // 원하는 높이로 설정
              decoration: const BoxDecoration(
                color: Color(0xFFECDFBB), // 갈색 배경색 (#ECDFBB)
              ),
            ),
          ),
        ],
      ),
      // Floating Action Button in the center
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const TodoSubmissionScreen(), // 'todo' 화면으로 이동
            ),
          );
        },
        child: Container(
          width: 40, // 변경: 40
          height: 40, // 변경: 40
          padding: const EdgeInsets.all(8), // 변경: padding 8
          decoration: ShapeDecoration(
            color: Colors.white, // 변경: 배경색 흰색
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                  width: 0.5, color: Color(0x3F1B1C1B)), // 변경: 테두리
              borderRadius: BorderRadius.circular(20), // 변경: borderRadius 20
            ),
          ),
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              // clipBehavior: Clip.antiAlias, // 제거: 오류의 원인
              child: SvgPicture.asset(
                'assets/icons/plus.svg', // 사용하고자 하는 아이콘 경로로 변경
                width: 20,
                height: 20,
                color: Colors.blueAccent, // 아이콘 색상 설정
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, // 가운데 위치
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        color: Colors.white, // 네비게이션 바 배경색 흰색
        child: SizedBox(
          height: 60, // 네비게이션 바 높이 설정
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround, // 네비게이션 바 버튼을 균등 분배
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/goal.svg',
                  width: 24,
                  height: 24,
                  // ignore: deprecated_member_use
                  color: Colors.grey,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GoalManagementScreen(), // 'goal_input' 화면으로 이동
                    ),
                  );
                },
              ),
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/eisenhower.svg',
                  width: 24,
                  height: 24,
                  color: Colors.grey,
                ),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const EisenhowerMatrixScreen()),
                  // );
                },
              ),
              const SizedBox(width: 48), // 플로팅 버튼 공간 확보
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/stats.svg',
                  width: 24,
                  height: 24,
                  color: Colors.grey,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GoalProgressScreen()),
                  );
                },
              ),
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/mypage.svg',
                  width: 24,
                  height: 24,
                  color: Colors.grey,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('마이페이지는 구현중입니다!')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
