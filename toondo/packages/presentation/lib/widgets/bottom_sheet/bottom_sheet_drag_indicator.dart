import 'package:flutter/material.dart';

class BottomSheetDragIndicator extends StatelessWidget {
  const BottomSheetDragIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 126,
        height: 8,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Color(0xFFDAEBCB),
            borderRadius: BorderRadius.all(Radius.circular(1000)),
          ),
        ),
      ),
    );
  }
}
