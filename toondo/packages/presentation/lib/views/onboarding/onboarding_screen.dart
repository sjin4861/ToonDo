// lib/views/onboarding/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/onboarding/onboarding_viewmodel.dart';
import 'package:presentation/views/onboarding/onboarding2_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OnboardingViewModel>(
      create: (_) => GetIt.instance<OnboardingViewModel>(),
      child: Builder(
        builder: (context) {
          final viewModel = Provider.of<OnboardingViewModel>(context);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!viewModel.initialized) {
              viewModel.initialize(context);
            }
          });
          return Scaffold(
            backgroundColor: const Color(0xFFFCFCFC),
            body: Stack(
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
                        colors: [
                          Color.fromRGBO(252, 241, 190, 1),
                          Color.fromRGBO(249, 228, 123, 1),
                        ],
                      ),
                      shape: OvalBorder(),
                    ),
                  ),
                ),
                // 텍스트
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.5 - 100,
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
                  left: MediaQuery.of(context).size.width * 0.5 - 93.14,
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
    );
  }
}