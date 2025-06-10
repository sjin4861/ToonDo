import 'package:flutter/material.dart';
import 'package:presentation/widgets/my_page/my_page_profile_section.dart';
import 'package:presentation/widgets/my_page/my_page_setting_section.dart';

class MyPageBody extends StatelessWidget {
  const MyPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
    );
  }
}
