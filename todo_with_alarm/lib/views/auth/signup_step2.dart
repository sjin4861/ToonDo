
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth/signup_viewmodel.dart';

class SignupStep2 extends StatefulWidget {
  @override
  _SignupStep2State createState() => _SignupStep2State();
}

class _SignupStep2State extends State<SignupStep2> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignupViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            viewModel.goBack();
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
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
            if (viewModel.passwordError != null) ...[
              SizedBox(height: 4),
              Text(
                viewModel.passwordError!,
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
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      viewModel.goBack();
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
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.21,
                        fontFamily: 'Pretendard Variable',
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      viewModel.validatePassword();
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
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.21,
                        fontFamily: 'Pretendard Variable',
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
