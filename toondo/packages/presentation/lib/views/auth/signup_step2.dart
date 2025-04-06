import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/bottom_button/custom_button.dart';
import 'package:presentation/widgets/text_fields/custom_auth_text_field.dart';
import 'package:presentation/viewmodels/signup/signup_viewmodel.dart';
import 'package:presentation/views/onboarding/onboarding_screen.dart';

class SignupStep2 extends StatelessWidget {
  final String phoneNumber; // 휴대폰 번호 의존성 추가
  final ValueNotifier<bool> isPasswordVisible = ValueNotifier(false);
  SignupStep2({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignupViewModel>.value(
      value: GetIt.instance<SignupViewModel>(),
      child: Consumer<SignupViewModel>(
        builder: (context, signupViewModel, child) {
          if (signupViewModel.phoneNumber.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              signupViewModel.setPhoneNumber(phoneNumber);
            });
          }
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
                  CustomAuthTextField(
                    key: const Key('signupStep2_phoneNumberField'),
                    label: '휴대폰 번호',
                    controller: signupViewModel.phoneNumberController,
                    readOnly: true,
                  ),
                  SizedBox(height: 24),
                  // 비밀번호 입력란을 ValueNotifier로 관리
                  CustomAuthTextField(
                    key: const Key('signupStep2_passwordField'),
                    label: '비밀번호',
                    hintText: '비밀번호를 입력하세요',
                    obscureTextNotifier: isPasswordVisible,
                    onChanged: (value) {
                      signupViewModel.password = value;
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    suffixIcon: ValueListenableBuilder<bool>(
                      valueListenable: isPasswordVisible,
                      builder: (context, value, child) {
                        return IconButton(
                          icon: Icon(
                            value ? Icons.visibility : Icons.visibility_off,
                            color: Color(0xFF1C1D1B),
                          ),
                          onPressed: () {
                            isPasswordVisible.value = !value;
                          },
                        );
                      },
                    ),
                    controller: signupViewModel.passwordController,
                    errorText: signupViewModel.passwordError,
                    isValid: signupViewModel.passwordError == null,
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
                  Spacer(),
                  // 버튼들
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CustomButton(
                          key: const Key('signupStep2_backButton'),
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
                          key: const Key('signupStep2_nextButton'),
                          text: '다음으로',
                          onPressed: () async {
                            await signupViewModel.validatePassword();
                            if (signupViewModel.passwordError != null) return;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OnboardingScreen(),
                              ),
                            );
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
      ),
    );
  }
}