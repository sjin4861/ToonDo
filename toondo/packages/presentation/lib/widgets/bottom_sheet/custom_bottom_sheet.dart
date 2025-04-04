import 'package:flutter/material.dart';
import 'package:presentation/widgets/bottom_sheet/bottom_sheet_drag_indicator.dart';

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final Widget? body;
  final List<CommonBottomSheetButtonData> buttons;

  const CustomBottomSheet({
    super.key,
    required this.title,
    this.body,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    final hasBody = body != null;
    final initialSize = hasBody ? 0.35 : 0.35;
    final maxSize = hasBody ? 0.35 : 0.35;

    return DraggableScrollableSheet(
      initialChildSize: initialSize,
      minChildSize: 0.3,
      maxChildSize: maxSize,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFDFDFD),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: ListView(
            controller: scrollController,
            shrinkWrap: true,
            children: [
              const BottomSheetDragIndicator(),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111111),
                    fontFamily: 'Pretendard Variable',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (hasBody) ...[
                body!,
                const SizedBox(height: 24),
              ],
              ...buttons.map(
                    (button) => Padding(
                  padding: const EdgeInsets.only(bottom: 22),
                  child: _CommonBottomSheetButton(
                    label: button.label,
                    filled: button.filled,
                    onPressed: button.onPressed,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CommonBottomSheetButtonData {
  final String label;
  final bool filled;
  final VoidCallback onPressed;

  CommonBottomSheetButtonData({
    required this.label,
    required this.filled,
    required this.onPressed,
  });
}

class _CommonBottomSheetButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onPressed;

  const _CommonBottomSheetButton({
    required this.label,
    required this.filled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final style = filled
        ? ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF78B545),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    )
        : OutlinedButton.styleFrom(
      side: const BorderSide(color: Color(0xFF78B545)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    );

    final child = Text(
      label,
      style: TextStyle(
        color: filled ? Colors.white : const Color(0xFF78B545),
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        fontFamily: 'Pretendard Variable',
      ),
    );

    return Center(
      child: SizedBox(
        width: 212,
        height: 44,
        child: filled
            ? ElevatedButton(onPressed: onPressed, style: style, child: child)
            : OutlinedButton(onPressed: onPressed, style: style, child: child),
      ),
    );
  }
}
