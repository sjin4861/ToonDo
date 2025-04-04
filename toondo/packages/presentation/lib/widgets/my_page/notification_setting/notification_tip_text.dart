import 'package:flutter/material.dart';

class NotificationTipText extends StatelessWidget {
  const NotificationTipText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TIP  ',
          style: TextStyle(
            color: Color(0xFF78B545),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            '원하는 시간에 to-do 작성 알림을 받아보세요!',
            style: TextStyle(
              color: Color(0xFF1C1D1B),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
