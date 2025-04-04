import 'package:flutter/material.dart';

class NotificationTimeTile extends StatelessWidget {
  final String timeText;

  const NotificationTimeTile({
    super.key,
    required this.timeText,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text(
        '리마인드 알림 시간',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF1C1D1B),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            timeText,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF1C1D1B),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFD9D9D9)),
        ],
      ),
      onTap: () {
        // 시간 선택 화면 연결 예정
      },
    );
  }
}
