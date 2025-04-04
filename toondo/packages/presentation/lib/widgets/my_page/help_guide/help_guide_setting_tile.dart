import 'package:flutter/material.dart';

class HelpGuideSettingTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const HelpGuideSettingTile({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // TODO: 라우팅 추가 예정
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(vertical: 14),
        color: const Color(0xFFFCFCFC),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF1C1D1B),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Pretendard Variable',
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFFD9D9D9),
            ),
          ],
        ),
      ),
    );
  }
}
