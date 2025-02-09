import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_alarm/widgets/app_bar/custom_app_bar.dart';
import 'package:todo_with_alarm/widgets/bottom_button/custom_button.dart';
import 'package:todo_with_alarm/widgets/text_fields/custom_text_field.dart';
import '../../viewmodels/auth/signup_viewmodel.dart';
import '../onboarding/onboarding_screen.dart'; // OnboardingScreen 임포트

class SignupStep2 extends StatefulWidget {
  @override
  _SignupStep2State createState() => _SignupStep2State();
}

class _SignupStep2State extends State<SignupStep2> {
  bool isPasswordVisible = false;
  SignupViewModel? viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (viewModel == null) {
      viewModel = Provider.of<SignupViewModel>(context);
      viewModel!.addListener(_onSignupComplete);
    }
  }

  @override
  void dispose() {
    viewModel?.removeListener(_onSignupComplete);
    super.dispose();
  }

  void _onSignupComplete() {
    if (viewModel!.isSignupComplete) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OnboardingScreen(userId: viewModel!.userId!),
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<SignupViewModel>(
      builder: (context, signupViewModel, child) {
        return Scaffold(
          backgroundColor: Color(0xFFFCFCFC),
          appBar: CustomAppBar(
            title: '회원가입',
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(24, 32, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 안내 문구
                Text(
                  '툰두와 처음 만나셨네요! 👋🏻',
                  style: TextStyle(
                    color: Color(0xFF78B545),
                    fontSize: 16,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.24,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '영문과 숫자를 조합한 8~20자의 비밀번호를 만들어주세요.',
                  style: TextStyle(
                    color: Color(0xBF1C1D1B),
                    fontSize: 10,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.15,
                  ),
                ),
                SizedBox(height: 32),
                // 휴대폰 번호 입력란
                CustomTextField(
                  key: const Key('signupStep2_phoneNumberField'), // ★ 추가
                  label: '휴대폰 번호',
                  hintText: '',
                  controller: TextEditingController(text: signupViewModel.phoneNumber),
                  enabled: false,
                  isValid: false, // 입력 불가능하므로 유효성 표시 필요 없음
                  borderColor: Color(0xFFDDDDDD), // 기본 테두리 색상 적용
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                SizedBox(height: 24),
                // 비밀번호 입력란
                CustomTextField(
                  key: const Key('signupStep2_passwordField'), // ★ 추가
                  label: '비밀번호',
                  hintText: '비밀번호를 입력하세요',
                  obscureText: !isPasswordVisible,
                  onChanged: (value) {
                    setState(() {
                      signupViewModel.password = value;
                    });
                  },
                  // errorText: signupViewModel.passwordError,
                  isValid: signupViewModel.password.isNotEmpty,
                  borderColor: signupViewModel.password.isNotEmpty
                      ? Color(0xFF78B545)
                      : Color(0xFFDDDDDD),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Color(0xFF1C1D1B),
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
                if (signupViewModel.passwordError != null) ...[
                  SizedBox(height: 4),
                  Text(
                    signupViewModel.passwordError!,
                    style: TextStyle(
                      color: Color(0xFFEE0F12),
                      fontSize: 10,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.15,
                    ),
                  ),
                ],
                Spacer(), // 남은 공간을 차지하여 아래 버튼들을 아래로 밀어냄
                // 버튼들
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CustomButton(
                        key: const Key('signupStep2_backButton'), // ★ 추가
                        text: '뒤로',
                        onPressed: () {
                          signupViewModel.goBack();
                        },
                        backgroundColor: Color(0xFFEEEEEE),
                        textColor: Color(0x7F1C1D1B),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: CustomButton(
                        key: const Key('signupStep2_nextButton'), // ★ 추가
                        text: '다음으로',
                        onPressed: () {
                          signupViewModel.validatePassword();
                          _onSignupComplete();
                        },
                        backgroundColor: Color(0xFF78B545),
                        textColor: Color(0xFFFCFCFC),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}