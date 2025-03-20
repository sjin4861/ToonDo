import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:presentation/views/auth/signup_step2.dart';
import 'package:presentation/widgets/text_fields/custom_auth_text_field.dart';
import 'package:presentation/viewmodels/signup/signup_viewmodel.dart';

class SmsVerificationScreen extends StatelessWidget {
  const SmsVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signupViewModel = Provider.of<SignupViewModel>(context, listen: false);
    final phoneNumber = signupViewModel.phoneNumber;

    return ChangeNotifierProvider<SignupViewModel>.value(
      value: GetIt.instance<SignupViewModel>(),
      child: Consumer<SignupViewModel>(
        builder: (context, viewModel, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (viewModel.phoneNumber != phoneNumber) {
              viewModel.setPhoneNumber(phoneNumber);
            }
          });
          return Scaffold(
            backgroundColor: Color(0xFFFCFCFC),
            appBar: AppBar(
              backgroundColor: Color(0xFFFCFCFC),
              elevation: 0.5,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Color(0xFF1C1D1B)),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                '본인 인증',
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
              padding: EdgeInsets.fromLTRB(24, 64, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상단 안내 문구
                  Text(
                    '휴대폰 번호로 인증번호 전송',
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
                    '${viewModel.phoneNumber}로 전송된 인증번호를 입력해주세요.',
                    style: TextStyle(
                      color: Color(0xBF1C1D1B),
                      fontSize: 10,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.15,
                    ),
                  ),
                  SizedBox(height: 16),
                  // 인증번호 전송 버튼
                  ElevatedButton(
                    key: const Key('smsVerification_sendCodeButton'),
                    onPressed: viewModel.isSmsLoading
                        ? null
                        : () async {
                            await viewModel.sendSmsCodeAndSetState();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF78B545),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      padding: EdgeInsets.all(16),
                    ),
                    child: Text(
                      '인증번호 전송',
                      style: TextStyle(
                        color: Color(0xFFFCFCFC),
                        fontSize: 14,
                        fontFamily: 'Pretendard Variable',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.21,
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  // 인증코드 입력란
                  CustomAuthTextField(
                    key: const Key('smsVerification_codeField'),
                    label: '인증코드',
                    hintText: '인증번호를 입력하세요',
                    controller: viewModel.smsCodeController,
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 24),
                  if (viewModel.smsMessage.isNotEmpty)
                    Text(
                      viewModel.smsMessage,
                      style: TextStyle(
                        color: viewModel.smsMessage.contains("성공")
                            ? Color(0xFF78B545)
                            : Color(0xFFEE0F12),
                        fontSize: 10,
                        fontFamily: 'Pretendard Variable',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.15,
                      ),
                    ),
                  Spacer(),
                  // 뒤로, 다음 버튼
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          key: const Key('smsVerification_backButton'),
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFEEEEEE),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1000)),
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
                          key: const Key('smsVerification_nextButton'),
                          onPressed: viewModel.isSmsLoading
                              ? null
                              : () async {
                                  try {
                                    await viewModel.verifySmsCodeAndSetState();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignupStep2(
                                            phoneNumber: viewModel.phoneNumber),
                                      ),
                                    );
                                  } catch (e) {
                                    // viewModel에 에러 메시지 설정되어 있음
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF78B545),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1000)),
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
        },
      ),
    );
  }
}
