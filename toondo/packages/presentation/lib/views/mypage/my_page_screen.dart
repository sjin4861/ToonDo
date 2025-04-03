import 'package:flutter/material.dart';
import 'package:presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:presentation/widgets/my_page/my_page_profile_section.dart';
import 'package:presentation/widgets/my_page/my_page_setting_section.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: CustomAppBar(title: '마이페이지'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 30),
              MyPageProfileSection(),
              SizedBox(height: 32),
              Divider(color: Color(0xFFDADADA), height: 1),
              SizedBox(height: 32),
              MyPageSettingSection(),
            ],
          ),
        ),
      ),
    );
  }
}
