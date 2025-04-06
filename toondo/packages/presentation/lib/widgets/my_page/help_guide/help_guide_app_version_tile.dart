import 'package:flutter/material.dart';

class HelpGuideAppVersionTile extends StatelessWidget {
  const HelpGuideAppVersionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(vertical: 14),
      color: const Color(0xFFFCFCFC),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '앱 버전',
            style: TextStyle(
              color: Color(0xFF1C1D1B),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Pretendard Variable',
            ),
          ),
          Text(
            '1.0.1',
            style: TextStyle(
              color: Color(0xff858584),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Pretendard Variable',
            ),
          ),
        ],
      ),
    );
  }
}
