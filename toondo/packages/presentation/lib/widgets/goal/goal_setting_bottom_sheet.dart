import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../bottom_button/custom_button.dart';
import 'package:domain/entities/goal.dart';

/// 목표 작성 성공 시 표시할 BottomSheet 위젯
class GoalSettingBottomSheet extends StatelessWidget {
  final Goal goal;

  GoalSettingBottomSheet({required this.goal, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String defaultIconPath = 'assets/icons/100point.svg';

    return Container(
      width: double.infinity,
      height: 320, // 디자인에 맞춘 높이
      decoration: const BoxDecoration(
        color: Colors.white, // 흰색 배경
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)), // 상단 모서리 둥글게
      ),
      child: Stack(
        children: [
          // 상단 드래그 핸들 (작은 바)
          Positioned(
            top: 16,
            left: (MediaQuery.of(context).size.width / 2) - 63, // 화면 중앙에 위치
            child: Container(
              width: 126,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFFDAEBCB),
                borderRadius: BorderRadius.circular(1000),
              ),
            ),
          ),
          // 제목 텍스트
          Positioned(
            top: 59,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '목표 설정을 완료했어요!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF111111),
                  fontSize: 18,
                  fontFamily: 'Pretendard Variable',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.27,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Positioned(
            top: 100, // 디자인에 맞춘 위치 조정
            left: 0,
            right: 0,
            child: Center(
              child: SvgPicture.asset(
                goal.icon ?? defaultIconPath, // 아이콘이 null일 경우 기본 아이콘 사용
                width: 60,
                height: 60,
                placeholderBuilder: (context) => const CircularProgressIndicator(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 추가 정보 텍스트 1
          Positioned(
            top: 172,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                goal.name,
                style: TextStyle(
                  color: const Color(0xFF1C1D1B),
                  fontSize: 12,
                  fontFamily: 'Pretendard Variable',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                  letterSpacing: 0.18,
                ),
              ),
            ),
          ),

          // 추가 정보 텍스트 2
          Positioned(
            top: 194,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                // 아래처럼 목표의 설정 일자가 나오게 해야함
                //'24.12.25 - 25.01.09',
                '${goal.startDate.toLocal().toString().split(' ')[0]} - ${goal.endDate.toLocal().toString().split(' ')[0]}', // 목표 시작일과 종료일 표시
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF858584),
                  fontSize: 10,
                  fontFamily: 'Pretendard Variable',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                  letterSpacing: 0.15,
                ),
              ),
            ),
          ),
          // 확인 버튼
          Positioned(
            bottom: 24,
            left: 82,
            right: 82,
            child: CustomButton(
              text: '확인하기',
              onPressed: () {
                Navigator.pop(context); // BottomSheet 닫기
                Navigator.pop(context); // 목표 입력 화면 닫기 (목표 목록 화면으로 돌아감)
              },
              backgroundColor: const Color(0xFF78B545),
              textColor: const Color(0xFFEEEEEE),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.24,
              padding: 12.0,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }
}