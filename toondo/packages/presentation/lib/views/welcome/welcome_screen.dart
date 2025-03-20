import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/viewmodels/welcome/welcome_viewmodel.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Provide WelcomeViewModel using getIt
    return ChangeNotifierProvider<WelcomeViewModel>.value(
      value: getIt<WelcomeViewModel>(),
      child: Builder(builder: (context) {
        // Trigger postframe side-effect to check login status
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<WelcomeViewModel>(context, listen: false).checkIfLoggedIn(context);
        });
        return Scaffold(
          body: Consumer<WelcomeViewModel>(
            builder: (context, viewModel, child) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.21, -0.98),
                    end: Alignment(-0.21, 0.98),
                    colors: [Color(0xFFC9E1B4), Color(0xFF93C46A)],
                  ),
                ),
                child: Stack(
                  children: [
                    // 하얀 타원 배경
                    Positioned(
                      left: -198,
                      top: MediaQuery.of(context).size.height * 0.33,
                      child: Container(
                        width: 770,
                        height: 870,
                        decoration: ShapeDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromRGBO(252, 241, 190, 1),
                              Color.fromRGBO(249, 228, 123, 1),
                            ],
                          ),
                          shape: OvalBorder(),
                        ),
                      ),
                    ),
                    // 캐릭터 및 그림자
                    Positioned(
                      left: MediaQuery.of(context).size.width * 0.5 - 86.5,
                      top: MediaQuery.of(context).size.height * 0.22,
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/character.svg',
                            width: 173,
                            height: 124.88,
                          ),
                          SizedBox(height: 4),
                          SvgPicture.asset(
                            'assets/icons/shadow.svg',
                            width: 130.61,
                            height: 20.62,
                          ),
                        ],
                      ),
                    ),
                    // 메인 텍스트
                    Positioned(
                      left: 24,
                      right: 24,
                      top: MediaQuery.of(context).size.height * 0.55,
                      child: Column(
                        children: [
                          Text(
                            '오늘부터 툰두와 함께 갓생을 시작해볼까요?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xBF1C1D1B),
                              fontSize: 10,
                              fontFamily: 'Pretendard Variable',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.15,
                            ),
                          ),
                          SizedBox(height: 8),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '당신의 똑똑한 갓생 도우미, ',
                                  style: TextStyle(
                                    color: Color(0xFF1C1D1B),
                                    fontSize: 16,
                                    fontFamily: 'Pretendard Variable',
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.24,
                                  ),
                                ),
                                TextSpan(
                                  text: 'TOONDO',
                                  style: TextStyle(
                                    color: Color(0xFF78B545),
                                    fontSize: 16,
                                    fontFamily: 'Pretendard Variable',
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 버튼들
                    Positioned(
                      left: 24,
                      right: 24,
                      bottom: MediaQuery.of(context).size.height * 0.12,
                      child: Column(
                        children: [
                          _buildSocialButton(
                            key: const Key('continueWithGoogleButton'),
                            context,
                            label: '구글로 계속하기',
                            color: Colors.white,
                            textColor: Color(0xFF1C1D1B),
                            borderColor: Color(0xFFDDDDDD),
                            iconPath: 'assets/images/google.png',
                            onPressed: () {
                              viewModel.navigateToOnboarding(context);
                            },
                          ),
                          SizedBox(height: 16),
                          _buildSocialButton(
                            key: const Key('continueWithoutLoginButton'),
                            context,
                            label: '카카오로 계속하기',
                            color: Color(0xFFFDDC3F),
                            textColor: Color(0xFF1C1D1B),
                            iconPath: 'assets/images/kakao.png',
                            onPressed: () {
                              viewModel.continueWithoutLogin(context);
                            },
                          ),
                          SizedBox(height: 16),
                          _buildSocialButton(
                            key: const Key('continueWithPhoneNumberButton'),
                            context,
                            label: '휴대폰 번호로 계속하기',
                            color: Color(0xFFC9E1B4),
                            textColor: Color(0xFF1C1D1B),
                            iconPath: 'assets/images/phone.png',
                            onPressed: () {
                              viewModel.continueWithPhoneNumber(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    // 하단 텍스트
                    Positioned(
                      left: 24,
                      right: 24,
                      bottom: MediaQuery.of(context).size.height * 0.05,
                      child: Text(
                        '버튼을 눌러 다음 화면으로 이동 시,\n서비스 이용 약관 및 개인정보 처리 방안에 동의한 것으로 간주합니다.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF948436),
                          fontSize: 8,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required String label,
    required Color color,
    required Color textColor,
    Color? borderColor,
    required String iconPath,
    required VoidCallback onPressed,
    required Key key,
  }) {
    return ElevatedButton(
      key: key,
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: color,
        minimumSize: Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1000),
          side: borderColor != null ? BorderSide(color: borderColor) : BorderSide.none,
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, width: 32, height: 32),
          SizedBox(width: 16),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontFamily: 'Pretendard Variable',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.21,
            ),
          ),
        ],
      ),
    );
  }
}
