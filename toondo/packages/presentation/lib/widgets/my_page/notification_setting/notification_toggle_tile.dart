import 'package:flutter/material.dart';

class NotificationToggleTile extends StatelessWidget {
  final String title;
  final bool value;
  final void Function(bool)? onChanged;

  const NotificationToggleTile({
    super.key,
    required this.title,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Theme(
      data: Theme.of(context).copyWith(
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith<Color>(
                (states) => const Color(0xFFFDFDFD),
          ),
          trackColor: WidgetStateProperty.resolveWith<Color>(
                (states) => states.contains(MaterialState.selected)
                ? const Color(0xFF78B545)
                : const Color(0xFFD9D9D9),
          ),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        ),
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: textColor,
          ),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
