import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_with_alarm/viewmodels/onboarding/onboarding_viewmodel.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OnboardingViewModel>(
      create: (_) => OnboardingViewModel(),
      child: Scaffold(
        body: Consumer<OnboardingViewModel>(
          builder: (context, viewModel, child) {
            return Container(
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
                    left: 82.50,
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
            );
          },
        ),
      ),
    );
  }
}