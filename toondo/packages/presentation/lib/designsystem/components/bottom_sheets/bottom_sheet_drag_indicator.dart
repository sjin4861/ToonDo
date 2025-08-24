import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';

class BottomSheetDragIndicator extends StatelessWidget {
  const BottomSheetDragIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 126.w,
        height: 8.h,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFDAEBCB),
            borderRadius: BorderRadius.all(Radius.circular(AppDimensions.radiusPill)),
          ),
        ),
      ),
    );
  }
}
