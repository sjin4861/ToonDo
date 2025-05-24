import 'package:flutter/material.dart';

class HelpGuideSettingTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const HelpGuideSettingTile({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return InkWell(
      onTap: onTap, // TODO: 라우팅 추가 예정
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
                fontFamily: 'Pretendard Variable',
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: IconTheme.of(context).color,
            ),
          ],
        ),
      ),
    );
  }
}
