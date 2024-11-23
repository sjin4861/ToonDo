import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    viewModel = Provider.of<SignupViewModel>(context);

    return Scaffold(
      backgroundColor: Color(0xFFFCFCFC),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(52),
        child: AppBar(
          backgroundColor: Color(0xFFFCFCFC),
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF1C1D1B)),
            onPressed: () {
              viewModel!.goBack();
            },
          ),
          title: Text(
            '회원가입',
            style: TextStyle(
              color: Color(0xFF1C1D1B),
              fontSize: 16,
              fontFamily: 'Pretendard Variable',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.24,
            ),
          ),
          centerTitle: false,
        ),
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
              label: '휴대폰 번호',
              hintText: '',
              controller: TextEditingController(text: viewModel!.phoneNumber),
              enabled: false,
              isValid: false, // 입력 불가능하므로 유효성 표시 필요 없음
              borderColor: Color(0xFFDDDDDD), // 기본 테두리 색상 적용
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            SizedBox(height: 24),
            // 비밀번호 입력란
            CustomTextField(
              label: '비밀번호',
              hintText: '비밀번호를 입력하세요',
              obscureText: !isPasswordVisible,
              onChanged: (value) {
                setState(() {
                  viewModel!.password = value;
                });
              },
              // errorText: viewModel!.passwordError,
              isValid: viewModel!.password.isNotEmpty,
              borderColor: viewModel!.password.isNotEmpty
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
            if (viewModel!.passwordError != null) ...[
              SizedBox(height: 4),
              Text(
                viewModel!.passwordError!,
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
                  child: ElevatedButton(
                    onPressed: () {
                      viewModel!.goBack();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEEEEEE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      padding: EdgeInsets.all(16),
                    ),
                    child: Text(
                      '뒤로',
                      style: TextStyle(
                        color: Color(0x7F1C1D1B),
                        fontSize: 14,
                        fontFamily: 'Pretendard Variable',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.21,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      viewModel!.validatePassword();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF78B545),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      padding: EdgeInsets.all(16),
                    ),
                    child: Text(
                      '다음으로',
                      style: TextStyle(
                        color: Color(0xFFFCFCFC),
                        fontSize: 14,
                        fontFamily: 'Pretendard Variable',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.21,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}