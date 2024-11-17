import 'dart:async'; // Timer를 사용하기 위해 추가
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_with_alarm/viewmodels/onboarding/onboarding_viewmodel.dart';
import 'onboarding2_screen.dart'; // Onboarding2Page 임포트

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Timer? _timer; // Timer 인스턴스 저장

  @override
  void initState() {
    super.initState();
    // 3초 후에 Onboarding2Page로 이동
    _timer = Timer(Duration(seconds: 3), () {
      if (mounted) { // 위젯이 마운트된 상태인지 확인
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Onboarding2Page()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Timer 취소
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFFFCFCFC),
        child: Stack(
          children: [
            // 하얀 타원 배경
            Positioned(
              left: -79.64,
              top: MediaQuery.of(context).size.height * 0.66,
              child: Container(
                width: 534.28,
                height: 483.32,
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.38, -0.93),
                    end: Alignment(-0.38, 0.93),
                    colors: [Color(0xFFFDFDFD), Color(0xFFFCF1BD)],
                  ),
                  shape: OvalBorder(),
                ),
              ),
            ),
            // 텍스트
            Positioned(
              left: MediaQuery.of(context).size.width * 0.5 - 100, // 화면의 중앙에 텍스트를 배치하기 위해 조정
              top: MediaQuery.of(context).size.height * 0.32,
              child: Text(
                '반가워요!\n제 이름은 슬라임이에요 😄',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF78B545),
                  fontSize: 20,
                  fontFamily: 'Pretendard Variable',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.30,
                ),
              ),
            ),
            // 캐릭터 및 그림자
            Positioned(
              left: MediaQuery.of(context).size.width * 0.5 - 93.14, // 이미지의 절반 너비를 빼서 중앙 정렬
              top: MediaQuery.of(context).size.height * 0.53,
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/icons/character.svg',
                    width: 186.29,
                    height: 134.30,
                  ),
                  SizedBox(height: 12.44),
                  SvgPicture.asset(
                    'assets/icons/shadow.svg',
                    width: 139.30,
                    height: 21.99,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}