import 'package:flutter/material.dart';
import 'package:todo_with_alarm/services/sms_service.dart';
import 'signup_step2.dart';

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
    _sendCode(); // 화면 로딩 시 자동 전송
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
      final result = await _smsService.verifySmsCode(widget.phoneNumber, _codeController.text);
      setState(() {
        _message = result;
      });
      // 인증 성공 시 SignupStep2로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignupStep2()),
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
      appBar: AppBar(title: Text("본인 인증")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("전화번호 ${widget.phoneNumber}로 인증번호를 전송했습니다."),
            SizedBox(height: 16),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(labelText: "인증번호 입력"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            if (_isLoading) CircularProgressIndicator(),
            if (!_isLoading)
              ElevatedButton(
                onPressed: _verifyCode,
                child: Text("인증하기"),
              ),
            SizedBox(height: 16),
            TextButton(
              onPressed: _sendCode,
              child: Text("재전송"),
            ),
            SizedBox(height: 16),
            Text(_message),
          ],
        ),
      ),
    );
  }
}
