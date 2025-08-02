import 'package:flutter/material.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';

class BottomSpacer extends StatelessWidget {
  const BottomSpacer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.bottomNavBarHeight,
      decoration: const BoxDecoration(
        color: Color(0xFFFCFCFC),
        border: Border(
          top: BorderSide(width: 1, color: Color(0x3F1C1D1B)),
        ),
      ),
    );
  }
}
