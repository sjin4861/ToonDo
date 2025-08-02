import 'package:flutter/material.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/widgets/bottom_sheet/bottom_sheet_drag_indicator.dart';

class CustomBottomSheet extends StatelessWidget {
  final String? title;
  final Widget? body;
  final List<CommonBottomSheetButtonData> buttons;
  final double initialSize;
  final double maxSize;
  final bool isScrollable;

  const CustomBottomSheet({
    super.key,
    this.title,
    this.body,
    required this.buttons,
    this.initialSize = 0.35,
    this.maxSize = 0.35,
    this.isScrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasBody = body != null;
    final hasTitle = title != null;

    final content = [
      const BottomSheetDragIndicator(),
      if (hasTitle) ...[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Center(
            child: Text(
              title!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111111),
                fontFamily: 'Pretendard Variable',
              ),
            ),
          ),
        ),
      ],
      if (hasBody) ...[
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 32),
          child: body!,
        ),
      ] else ...[
        const SizedBox(height: 16),
      ],
      ...buttons.map(
        (button) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _CommonBottomSheetButton(
            label: button.label,
            filled: button.filled,
            onPressed: button.onPressed,
            icon: button.icon,
          ),
        ),
      ),
    ];

    return DraggableScrollableSheet(
      initialChildSize: initialSize,
      minChildSize: initialSize - 0.1,
      maxChildSize: maxSize,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFDFDFD),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child:
              isScrollable
                  ? ListView(
                    controller: scrollController,
                    shrinkWrap: true,
                    children: content,
                  )
                  : SingleChildScrollView(child: Column(children: content)),
        );
      },
    );
  }
}

class CommonBottomSheetButtonData {
  final String label;
  final bool filled;
  final VoidCallback onPressed;
  final IconData? icon;

  CommonBottomSheetButtonData({
    required this.label,
    required this.filled,
    required this.onPressed,
    this.icon,
  });
}

class _CommonBottomSheetButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onPressed;
  final IconData? icon;

  const _CommonBottomSheetButton({
    required this.label,
    required this.filled,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        filled ? const Color(0xFF78B545) : Colors.transparent;
    final textColor = filled ? Colors.white : const Color(0xFF78B545);
    final border = BorderSide(color: const Color(0xFF78B545));

    return Center(
      child: SizedBox(
        width: 212,
        height: 44,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
              side: filled ? BorderSide.none : border,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: textColor),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.21,
                  fontFamily: 'Pretendard Variable',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
