import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presentation/widgets/bottom_sheet/custom_bottom_sheet.dart';

class GoalEditBottomSheet extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onRetry;
  final VoidCallback onDelete;

  const GoalEditBottomSheet({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onRetry,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      initialSize: 0.6,
      maxSize: 0.6,
      isScrollable: false,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF78B545), width: 1.2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: SvgPicture.asset(
                iconPath,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1C1D1B),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Pretendard Variable',
            ),
          ),
        ],
      ),
      buttons: [
        CommonBottomSheetButtonData(
          label: '수정하기',
          filled: true,
          onPressed: onRetry,
          icon: Icons.edit,
        ),
        CommonBottomSheetButtonData(
          label: '삭제하기',
          filled: false,
          onPressed: onDelete,
          icon: Icons.delete,
        ),
      ],
    );
  }
}
