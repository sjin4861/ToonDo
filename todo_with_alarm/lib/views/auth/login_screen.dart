import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth/login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
      create: (_) => LoginViewModel(),
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('로그인'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // 이전 화면으로 이동
                  Navigator.pop(context);
                },
              ),
              backgroundColor: Color(0xFFFCFCFC),
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(0.5),
                child: Container(
                  color: Color(0x3F1C1D1B),
                  height: 0.5,
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.all(24),
              child: ListView(
                children: [
                  SizedBox(height: 16),
                  Text(
                    '휴대폰 번호',
                    style: TextStyle(
                      color: Color(0xFF1C1D1B),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.15,
                      fontFamily: 'Pretendard Variable',
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      viewModel.phoneNumber = value;
                    },
                    decoration: InputDecoration(
                      hintText: '휴대폰 번호를 입력하세요.',
                      hintStyle: TextStyle(
                        color: Color(0xFFB2B2B2),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.18,
                        fontFamily: 'Pretendard Variable',
                      ),
                      errorText: viewModel.phoneError,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                        borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                        borderSide: BorderSide(color: Color(0xFF78B545)),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '비밀번호',
                    style: TextStyle(
                      color: Color(0xFF1C1D1B),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.15,
                      fontFamily: 'Pretendard Variable',
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    obscureText: !isPasswordVisible,
                    onChanged: (value) {
                      viewModel.password = value;
                    },
                    decoration: InputDecoration(
                      hintText: '비밀번호를 입력하세요.',
                      hintStyle: TextStyle(
                        color: Color(0xFFB2B2B2),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.18,
                        fontFamily: 'Pretendard Variable',
                      ),
                      errorText: viewModel.passwordError,
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xFF1C1D1B),
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                        borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000),
                        borderSide: BorderSide(color: Color(0xFF78B545)),
                      ),
                    ),
                  ),
                  if (viewModel.passwordError != null ||
                      viewModel.phoneError != null) ...[
                    SizedBox(height: 4),
                    Text(
                      viewModel.passwordError ?? viewModel.phoneError!,
                      style: TextStyle(
                        color: Color(0xFFEE0F12),
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.15,
                        fontFamily: 'Pretendard Variable',
                      ),
                    ),
                  ],
                  if (viewModel.loginError != null) ...[
                    SizedBox(height: 4),
                    Text(
                      viewModel.loginError!,
                      style: TextStyle(
                        color: Color(0xFFEE0F12),
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.15,
                        fontFamily: 'Pretendard Variable',
                      ),
                    ),
                  ],
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.login();
                      if (viewModel.loginError == null &&
                          viewModel.passwordError == null &&
                          viewModel.phoneError == null) {
                        // 로그인 성공 시 메인 화면으로 이동
                        Navigator.pushReplacementNamed(context, '/home');
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
                      '로그인',
                      style: TextStyle(
                        color: Color(0xFFFCFCFC),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.21,
                        fontFamily: 'Pretendard Variable',
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