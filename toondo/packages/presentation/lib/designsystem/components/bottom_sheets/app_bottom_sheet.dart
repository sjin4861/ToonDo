import 'package:flutter/material.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/components/bottom_sheets/bottom_sheet_drag_indicator.dart';

class AppBottomSheet extends StatelessWidget {
  final Widget body;
  final double? fixedHeight;
  final double initialSize;
  final double maxSize;
  final bool isScrollable;

  const AppBottomSheet({
    super.key,
    required this.body,
    this.fixedHeight,
    this.initialSize = 0.3,
    this.maxSize = 0.9,
    this.isScrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = [
      const SizedBox(height: AppSpacing.spacing22),
      const BottomSheetDragIndicator(),
      const SizedBox(height: AppSpacing.spacing30),
      body,
      const SizedBox(height: AppSpacing.spacing44),
    ];

    // ✨ fixedHeight가 설정된 경우: hug content 모드
    if (fixedHeight != null) {
      return Container(
        height: fixedHeight,
        decoration: const BoxDecoration(
          color: Color(0xFFFDFDFD),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.bottomSheetTopRadius),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: content),
        ),
      );
    }

    // ✨ 기본 Draggable Scroll Sheet 모드
    return DraggableScrollableSheet(
      initialChildSize: initialSize,
      minChildSize: initialSize - 0.1,
      maxChildSize: maxSize,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFDFDFD),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppDimensions.bottomSheetTopRadius),
            ),
          ),
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
