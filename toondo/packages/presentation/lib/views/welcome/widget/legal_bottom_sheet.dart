import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/bottom_sheets/app_bottom_sheet.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';

class LegalBottomSheet extends StatelessWidget {
  final String title;
  final String content;

  const LegalBottomSheet({
    super.key,
    required this.title,
    required this.content,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LegalBottomSheet(title: title, content: content),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      initialSize: 0.8,
      maxSize: 0.95,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.h20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTypography.h2Bold),
            SizedBox(height: AppSpacing.v20),
            Text(
              content,
              style: AppTypography.caption1Regular.copyWith(
                color: AppColors.status100_75,
                height: 1.55,
              ),
            ),
            SizedBox(height: AppSpacing.v32),
          ],
        ),
      ),
    );
  }
}
