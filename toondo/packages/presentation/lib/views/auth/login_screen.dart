import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:presentation/viewmodels/login/login_viewmodel.dart';
import 'package:presentation/widgets/text_fields/custom_auth_text_field.dart';
import 'package:get_it/get_it.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? passedPhoneNumber = ModalRoute.of(context)?.settings.arguments as String?;
    return ChangeNotifierProvider<LoginViewModel>.value(
      value: GetIt.instance<LoginViewModel>(),
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) {
          if (passedPhoneNumber != null && viewModel.phoneNumberController.text.isEmpty) {
            viewModel.phoneNumberController.text = passedPhoneNumber;
          }
          return Scaffold(
            backgroundColor: Color(0xFFFCFCFC),
            appBar: AppBar(
              backgroundColor: Color(0xFFFCFCFC),
              elevation: 0.5,
              automaticallyImplyLeading: false, // 이 속성으로 기본 뒤로가기 버튼 숨김
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
                    CustomAuthTextField(
                      key: const Key('login_phoneNumberField'),
                      label: '휴대폰 번호',
                      controller: viewModel.phoneNumberController,
                      readOnly: passedPhoneNumber != null,
                      hintText: passedPhoneNumber != null ? null : '휴대폰 번호를 입력하세요',
                    ),
                    // 휴대폰 번호 에러 메시지 (있을 경우)
                    if (viewModel.loginError != null &&
                        viewModel.phoneNumberController.text.trim().isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          viewModel.loginError!,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    SizedBox(height: 24),
                    CustomAuthTextField(
                      key: const Key('login_passwordField'),
                      label: '비밀번호',
                      controller: viewModel.passwordController, // 로그인 뷰모델 내 비밀번호 컨트롤러 사용
                      obscureText: !viewModel.isPasswordVisible,
                      onChanged: (value) {
                        viewModel.setPassword(value);
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          viewModel.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Color(0xFF1C1D1B),
                        ),
                        onPressed: () {
                          viewModel.togglePasswordVisibility();
                        },
                      ),
                    ),
                    // 비밀번호 에러 메시지 (있을 경우)
                    if (viewModel.passwordError != null)
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          viewModel.passwordError!,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Row(
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
                        print('로그인 시도 전화번호: ${viewModel.phoneNumberController.text}');
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
            ),
          );
        },
      ),
    );
  }
}