import 'package:flutter/material.dart';

class NotificationToggleTile extends StatelessWidget {
  final String title;
  final bool value;

  const NotificationToggleTile({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        switchTheme: SwitchThemeData(
          // 활성 상태
          thumbColor: WidgetStateProperty.resolveWith<Color>(
                (states) {
              if (states.contains(WidgetState.selected)) {
                return const Color(0xFFFDFDFD); // 동그라미
              }
              return const Color(0xFFFDFDFD); // 비활도 동일
            },
          ),
          trackColor: WidgetStateProperty.resolveWith<Color>(
                (states) {
              if (states.contains(MaterialState.selected)) {
                return const Color(0xFF78B545); // 활성 배경
              }
              return const Color(0xFFD9D9D9); // 비활 배경
            },
          ),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        ),
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF1C1D1B),
          ),
        ),
        value: value,
        onChanged: (_) {}, // TODO 추후 ViewModel 연결 예정
      ),
    );
  }
}
