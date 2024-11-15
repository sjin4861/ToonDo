import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth/signup_viewmodel.dart';

class SignupStep1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignupViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // 이전 화면으로 이동
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('휴대폰 번호'),
            SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                viewModel.phoneNumber = value;
              },
              decoration: InputDecoration(
                hintText: '휴대폰 번호를 입력하세요.',
                errorText: viewModel.phoneError,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                viewModel.validatePhoneNumber();
              },
              child: Text('다음으로'),
            ),
          ],
        ),
      ),
    );
  }
}