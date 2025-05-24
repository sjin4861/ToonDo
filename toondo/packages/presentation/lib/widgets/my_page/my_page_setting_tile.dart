import 'package:flutter/material.dart';

class MyPageSettingTile extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const MyPageSettingTile({super.key, required this.title, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(vertical: 14),
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: textColor,
                letterSpacing: 0.21,
                fontFamily: 'Pretendard Variable',
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
