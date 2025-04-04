import 'package:flutter/material.dart';

class DisplaySettingTitleSection extends StatelessWidget {
  const DisplaySettingTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '다크모드 설정',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1C1D1B),
        fontFamily: 'Pretendard Variable',
      ),
    );
  }
}
