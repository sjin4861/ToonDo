import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';

class BottomSheetDragIndicator extends StatelessWidget {
  final bool isGrey;

  const BottomSheetDragIndicator({
    super.key,
    this.isGrey = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 126.w,
        height: 8.h,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isGrey
                ? const Color(0xFFE0E0E0)
                : const Color(0xFFDAEBCB),
            borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusPill)),
          ),
        ),
      ),
    );
  }
}
