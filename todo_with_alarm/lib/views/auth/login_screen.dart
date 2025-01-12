import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth/login_viewmodel.dart';

class LoginScreen extends StatelessWidget {
  final String? phoneNumber; // 외부에서 전달되더라도 필드 입력이 가능하도록 함

  LoginScreen({this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
      create: (_) => LoginViewModel(phoneNumber: phoneNumber),
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) {
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
                '로그인',
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
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 32, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 상단 안내 문구
                    Text(
                      '다시 만나서 반가워요! 👋🏻',
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
                      '비밀번호를 입력하고 로그인하세요.',
                      style: TextStyle(
                        color: Color(0xBF1C1D1B),
                        fontSize: 10,
                        fontFamily: 'Pretendard Variable',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.15,
                      ),
                    ),
                    SizedBox(height: 32),
                    // 휴대폰 번호 입력 필드 (기존에는 표시만 했었음)
                    Text(
                      '휴대폰 번호',
                      style: TextStyle(
                        color: Color(0xFF1C1D1B),
                        fontSize: 10,
                        fontFamily: 'Pretendard Variable',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.15,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      key: const Key('login_phoneNumberField'),
                      controller: viewModel.phoneNumberController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        hintText: '휴대폰 번호를 입력하세요',
                        hintStyle: TextStyle(
                          color: Color(0xFFB2B2B2),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.18,
                          fontFamily: 'Pretendard Variable',
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000),
                          borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1000),
                          borderSide: BorderSide(color: Color(0xFF78B545)),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 24),
                    // 비밀번호 입력 필드
                    Text(
                      '비밀번호',
                      style: TextStyle(
                        color: Color(0xFF1C1D1B),
                        fontSize: 10,
                        fontFamily: 'Pretendard Variable',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.15,
                      ),
                    ),
                    SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          key: const Key('login_passwordField'),
                          obscureText: !viewModel.isPasswordVisible,
                          onChanged: (value) {
                            viewModel.password = value;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                            hintText: '비밀번호를 입력하세요.',
                            hintStyle: TextStyle(
                              color: Color(0xFFB2B2B2),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.18,
                              fontFamily: 'Pretendard Variable',
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                viewModel.isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Color(0xFF1C1D1B),
                              ),
                              onPressed: () {
                                viewModel.togglePasswordVisibility();
                              },
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1000),
                              borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1000),
                              borderSide: BorderSide(color: Color(0xFF78B545)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1000),
                              borderSide: BorderSide(color: Color(0xFFEE0F12)),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1000),
                              borderSide: BorderSide(color: Color(0xFFEE0F12)),
                            ),
                          ),
                        ),
                        if (viewModel.passwordError != null) ...[
                          SizedBox(height: 4),
                          Text(
                            viewModel.passwordError!,
                            style: TextStyle(
                              color: Color(0xFFEE0F12),
                              fontSize: 10,
                              fontFamily: 'Pretendard Variable',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.15,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 32),
                    // 버튼들
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            key: const Key('login_backButton'),
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
                            key: const Key('login_nextButton'),
                            onPressed: () async {
                              bool success = await viewModel.login();
                              if (success) {
                                // 로그인 성공 시 홈 화면으로 이동
                                Navigator.pushReplacementNamed(context, '/home');
                              } else {
                                // 로그인 실패 시 에러 메시지 표시
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(viewModel.loginError ?? '로그인에 실패했습니다.'),
                                  ),
                                );
                              }
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
            ),
          );
        },
      ),
    );
  }
}