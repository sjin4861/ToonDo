import 'package:flutter/material.dart';
import 'package:toondo/services/sms_service.dart';
import '../../../packages/presentaion/lib/widgets/text_fields/custom_text_field.dart';
import 'signup_step2.dart';
import '../../../packages/presentaion/lib/widgets/text_fields/custom_auth_text_field.dart';

class SmsVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  const SmsVerificationScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _SmsVerificationScreenState createState() => _SmsVerificationScreenState();
}

class _SmsVerificationScreenState extends State<SmsVerificationScreen> {
  final TextEditingController _codeController = TextEditingController();
  final SmsService _smsService = SmsService();
  String _message = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 제거: _sendCode(); // 자동 전송 제거
  }

  Future<void> _sendCode() async {
    setState(() {
      _isLoading = true;
      _message = "인증번호 전송 중...";
    });
    try {
      final result = await _smsService.sendSmsCode(widget.phoneNumber);
      setState(() {
        _message = result;
      });
    } catch (e) {
      setState(() {
        _message = e.toString();
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _verifyCode() async {
    setState(() {
      _isLoading = true;
      _message = "";
    });
    try {
      await _smsService.verifySmsCode(widget.phoneNumber, _codeController.text);
      // 인증 성공 시 SignupStep2로 이동 (전화번호는 그대로 유지)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignupStep2(phoneNumber: widget.phoneNumber,)),
      );
    } catch (e) {
      setState(() {
        _message = e.toString();
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
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
            // 상단 안내 문구 (signup_step1/2와 동일한 디자인)
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
              '${widget.phoneNumber}로 전송된 인증번호를 입력해주세요.',
              style: TextStyle(
                color: Color(0xBF1C1D1B),
                fontSize: 10,
                fontFamily: 'Pretendard Variable',
                fontWeight: FontWeight.w400,
                letterSpacing: 0.15,
              ),
            ),
            SizedBox(height: 16),
            // 인증번호 전송 버튼 추가
            ElevatedButton(
              key: const Key('smsVerification_sendCodeButton'),
              onPressed: _isLoading ? null : _sendCode,
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
            // 인증코드 입력란 (비밀번호 대신)
            CustomAuthTextField(
              key: const Key('smsVerification_codeField'),
              label: '인증코드',
              hintText: '인증번호를 입력하세요',
              controller: _codeController,
              onChanged: (value) {},
            ),
            SizedBox(height: 24),
            if (_message.isNotEmpty)
              Text(
                _message,
                style: TextStyle(
                  color: _message.contains("성공") ? Color(0xFF78B545) : Color(0xFFEE0F12),
                  fontSize: 10,
                  fontFamily: 'Pretendard Variable',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.15,
                ),
              ),
            Spacer(),
            // 뒤로, 다음 버튼 (signup_step1과 동일한 버튼 디자인)
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    key: const Key('smsVerification_backButton'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEEEEEE),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1000)),
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
                    onPressed: _isLoading ? null : _verifyCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF78B545),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1000)),
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
