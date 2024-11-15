import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth/signup_viewmodel.dart';

class SignupStep3 extends StatelessWidget {
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
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('닉네임'),
            SizedBox(height: 8),
            TextField(
              onChanged: (value) {
                viewModel.username = value;
              },
              decoration: InputDecoration(
                hintText: '닉네임을 입력하세요.',
                errorText: viewModel.usernameError,
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    viewModel.goBack();
                  },
                  child: Text('뒤로'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    viewModel.validateUsername();
                  },
                  child: Text('다음으로'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}