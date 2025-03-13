import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: Center(
          child: MyPage(),
        ),
      ),
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375,
      height: 812,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(color: Color(0xFFFCFCFC)),
      child: Stack(
        children: [
          // 상단 AppBar 영역: "마이페이지"
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 375,
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: ShapeDecoration(
                color: const Color(0xFFFCFCFC),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.5, color: const Color(0x3F1C1D1B)),
                ),
              ),
              child: Row(
                children: const [
                  SizedBox(
                    width: 16,
                    height: 16,
                    // 임시 아이콘 자리. 실제 아이콘으로 대체 가능.
                    child: Placeholder(strokeWidth: 1),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '마이페이지',
                    style: TextStyle(
                      color: Color(0xFF1C1D1B),
                      fontSize: 16,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 프로필 사진 영역
          Positioned(
            left: 24,
            top: 84,
            child: SizedBox(
              width: 85,
              height: 85,
              child: Stack(
                children: [
                  // 바깥쪽 원 (배경)
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 85,
                      height: 85,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFE5E1F5),
                        shape: OvalBorder(),
                      ),
                    ),
                  ),
                  // 중간 원 (그라데이션)
                  Positioned(
                    left: 13,
                    top: 13,
                    child: Container(
                      width: 59,
                      height: 59,
                      decoration: const ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.5, 0),
                          end: Alignment(0.5, 1),
                          colors: [Color(0xFFC0AEFF), Color(0xFFAB94FD)],
                        ),
                        shape: OvalBorder(),
                      ),
                    ),
                  ),
                  // 아이콘 혹은 이미지 자리
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 85,
                      height: 85,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 프로필 텍스트 영역: 이름 및 활동 일수
          Positioned(
            left: 133,
            top: 98,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '드리머즈',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.24,
                  ),
                ),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'ToonDo',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.15,
                        ),
                      ),
                      const TextSpan(
                        text: '와 함께한 지 ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.15,
                        ),
                      ),
                      const TextSpan(
                        text: '21',
                        style: TextStyle(
                          color: Color(0xFF78B545),
                          fontSize: 10,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.15,
                        ),
                      ),
                      const TextSpan(
                        text: '일째',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // "설정" 타이틀 영역
          const Positioned(
            left: 24,
            top: 237,
            child: Text(
              '설정',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Pretendard Variable',
                fontWeight: FontWeight.w600,
                letterSpacing: 0.24,
              ),
            ),
          ),
          // 설정 옵션 목록
          Positioned(
            left: 0,
            top: 272,
            child: Container(
              width: 375,
              child: Column(
                children: [
                  // 옵션 Row 템플릿 (화면, 소리/알림, 계정관리, 이용안내 등)
                  _buildSettingRow(title: '동기화'),
                  _buildSettingRow(
                    title: '화면',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  _buildSettingRow(
                    title: '소리/알림',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  _buildSettingRow(
                    title: '계정관리',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  _buildSettingRow(
                    title: '이용안내',
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 설정 옵션 Row 빌더
  Widget _buildSettingRow({required String title, Widget? trailing}) {
    return Container(
      width: double.infinity,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      color: const Color(0xFFFCFCFC),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1C1D1B),
              fontSize: 14,
              fontFamily: 'Pretendard Variable',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.21,
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}
