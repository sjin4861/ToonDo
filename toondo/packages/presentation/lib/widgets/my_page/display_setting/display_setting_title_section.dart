import 'package:flutter/material.dart';

class DisplaySettingTitleSection extends StatelessWidget {
  const DisplaySettingTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Text(
      '다크모드 설정',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: textColor,
        fontFamily: 'Pretendard Variable',
      ),
    );
  }
}
