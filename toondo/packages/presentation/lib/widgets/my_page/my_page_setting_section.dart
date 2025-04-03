import 'package:flutter/material.dart';
import 'my_page_setting_tile.dart';

class MyPageSettingSection extends StatelessWidget {
  const MyPageSettingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          '설정',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 16),
        MyPageSettingTile(title: '동기화'),
        MyPageSettingTile(title: '화면', trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFD9D9D9)),),
        MyPageSettingTile(title: '소리/알림', trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFD9D9D9)),),
        MyPageSettingTile(title: '계정관리', trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFD9D9D9)),),
        MyPageSettingTile(title: '이용안내', trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFD9D9D9)),),
      ],
    );
  }
}
