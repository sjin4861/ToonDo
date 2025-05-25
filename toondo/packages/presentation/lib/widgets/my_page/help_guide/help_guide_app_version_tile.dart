import 'package:flutter/material.dart';

class HelpGuideAppVersionTile extends StatelessWidget {
  final String version;

  const HelpGuideAppVersionTile({super.key, required this.version});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(vertical: 14),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '앱 버전',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: textColor,
              fontFamily: 'Pretendard Variable',
            ),
          ),
          Text(
            version,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: textColor,
              fontFamily: 'Pretendard Variable',
            ),
          ),
        ],
      ),
    );
  }
}
