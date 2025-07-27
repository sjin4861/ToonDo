import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:presentation/views/auth/signup_step2.dart';
import 'package:presentation/viewmodels/signup/signup_viewmodel.dart';
import 'package:presentation/views/auth/login_screen.dart';
import 'package:presentation/widgets/text_fields/custom_auth_text_field.dart';

class SignupStep1 extends StatelessWidget {
  const SignupStep1({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupViewModel>(
      builder: (context, viewModel, child) {
        // 로그인 화면으로 이동하는 콜백 설정
        viewModel.setNavigateToLogin(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        });
        
        return Scaffold(
          backgroundColor: Color(0xFFFCFCFC),
          appBar: AppBar(
            backgroundColor: Color(0xFFFCFCFC),
            elevation: 0.5,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFF1C1D1B)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              '회원정보 확인',
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
            body: Padding(
              padding: EdgeInsets.fromLTRB(24, 64, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '아이디로 계속할게요',
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
                    '아이디를 입력하여 로그인하거나 가입하세요.',
                    style: TextStyle(
                      color: Color(0xBF1C1D1B),
                      fontSize: 10,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.15,
                    ),
                  ),
                  SizedBox(height: 32),
                  CustomAuthTextField(
                    key: const Key('signupStep1_loginIdField'),
                    label: '아이디',
                    hintText: 'user_name123',
                    controller: viewModel.loginIdController,
                    onChanged: (value) {
                      viewModel.setLoginId(value);
                    },
                  ),
                  if (viewModel.loginIdError != null) ...[
                    SizedBox(height: 4),
                    Text(
                      viewModel.loginIdError!,
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
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          key: const Key('signupStep1_backButton'),
                          onPressed: () {
                            Navigator.pop(context);
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
                          key: const Key('signupStep1_nextButton'),
                          onPressed: () async {
                            bool validationSuccess = await viewModel.validateLoginId();
                            if (validationSuccess && viewModel.loginIdError == null) {
                              // validateLoginId가 성공하면 다음 단계로 진행
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignupStep2(
                                      loginId: viewModel.loginId),
                                ),
                              );
                            }
                            // 검증 실패 시에는 화면에 머물러서 에러 메시지 표시
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
                  SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      );
  }
}