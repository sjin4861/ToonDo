import 'package:flutter/material.dart';

class NotificationTipText extends StatelessWidget {
  const NotificationTipText({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Row(
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}
