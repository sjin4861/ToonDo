import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../packages/presentaion/lib/widgets/app_bar/custom_app_bar.dart';
import '../../../packages/presentaion/lib/widgets/bottom_button/custom_button.dart';
import '../../../packages/presentaion/lib/widgets/text_fields/custom_text_field.dart';
import '../../viewmodels/auth/signup_viewmodel.dart';
import '../onboarding/onboarding_screen.dart'; // OnboardingScreen 임포트
import '../../../packages/presentaion/lib/widgets/text_fields/custom_auth_text_field.dart';

class SignupStep2 extends StatefulWidget {
  final String phoneNumber; // 휴대폰 번호 의존성 추가
  const SignupStep2({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _SignupStep2State createState() => _SignupStep2State();
}

class _SignupStep2State extends State<SignupStep2> {
  bool isPasswordVisible = false;
  SignupViewModel? viewModel;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController; // 신규 추가

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (viewModel == null) {
      viewModel = Provider.of<SignupViewModel>(context);
      // 휴대폰 번호가 viewmodel에 아직 설정되지 않은 경우 widget의 번호를 전달
      if (viewModel!.phoneNumber.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          viewModel!.setPhoneNumber(widget.phoneNumber);
        });
      }
      viewModel!.addListener(_onSignupComplete);
      _phoneController = TextEditingController(text: widget.phoneNumber); // widget.phoneNumber 사용
      _passwordController = TextEditingController(); // 초기화
    }
  }

  @override
  void dispose() {
    viewModel?.removeListener(_onSignupComplete);
    _phoneController.dispose();
    _passwordController.dispose(); // dispose 추가
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
                // 휴대폰 번호 입력란 (widget.phoneNumber 사용)
                CustomAuthTextField(
                  key: const Key('signupStep2_phoneNumberField'),
                  label: '휴대폰 번호',
                  controller: _phoneController,
                  readOnly: true,
                ),
                SizedBox(height: 24),
                // 비밀번호 입력란 (CustomTextField -> CustomAuthTextField 변경)
                CustomAuthTextField(
                  key: const Key('signupStep2_passwordField'),
                  label: '비밀번호',
                  hintText: '비밀번호를 입력하세요',
                  controller: _passwordController,
                  obscureText: !isPasswordVisible,
                  onChanged: (value) {
                    setState(() {
                      signupViewModel.password = value;
                    });
                  },
                  // errorText: signupViewModel.passwordError,
                  // 입력 시 border 색상은 내부 ValueListenableBuilder 에서 처리됨
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
                        onPressed: () async {
                          await signupViewModel.validatePassword();
                          // 버튼 눌렀을 때 유효하지 않은 비밀번호면 화면 전환 방지
                          if (signupViewModel.passwordError != null) return;
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