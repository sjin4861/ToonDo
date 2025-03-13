import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toondo/views/auth/sms_verification_screen.dart';
import '../../../packages/presentaion/lib/widgets/text_fields/custom_text_field.dart';
import '../../viewmodels/signup/signup_viewmodel.dart';
import 'login_screen.dart'; // 로그인 화면 임포트
import '../../../packages/presentaion/lib/widgets/text_fields/custom_auth_text_field.dart';

class SignupStep1 extends StatefulWidget {
  @override
  _SignupStep1State createState() => _SignupStep1State();
}

class _SignupStep1State extends State<SignupStep1> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignupViewModel>(context);

    return Scaffold(
      backgroundColor: Color(0xFFFCFCFC),
      appBar: AppBar(
        backgroundColor: Color(0xFFFCFCFC),
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF1C1D1B)),
          onPressed: () {
            // 이전 화면으로 이동
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
              '휴대폰 번호로 계속할게요',
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
              '휴대폰 번호를 입력하여 로그인하거나 가입하세요.',
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
              key: const Key('signupStep1_phoneNumberField'),
              label: '휴대폰 번호',
              hintText: '01012345678',
              controller: viewModel.phoneNumberController, // 뷰모델 내 컨트롤러 사용
              onChanged: (value) {
                setState(() {
                  viewModel.setPhoneNumber(value);
                });
              },
            ),
            if (viewModel.phoneError != null) ...[
              SizedBox(height: 4),
              Text(
                viewModel.phoneError!,
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
                    key: const Key('signupStep1_backButton'), // ★ 추가
                    onPressed: () {
                      // 이전 화면으로 이동
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
                    key: const Key('signupStep1_nextButton'), // ★ 추가
                    onPressed: () async {
                      bool alreadyRegistered = await viewModel.validatePhoneNumber();
                      if (viewModel.phoneError == null && viewModel.phoneNumber.isNotEmpty) {
                        // 전화번호가 이미 등록되어 있다면 로그인 화면으로 이동
                        if (alreadyRegistered) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LoginScreen(phoneNumber: viewModel.phoneNumber),
                            ),
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SmsVerificationScreen(phoneNumber: viewModel.phoneNumber),
                            ),
                          );
                        }
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
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}