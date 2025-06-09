import 'package:flutter/material.dart';

class BottomSpacer extends StatelessWidget {
  const BottomSpacer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Color(0xFFFCFCFC),
        border: Border(
          top: BorderSide(width: 1, color: Color(0x3F1C1D1B)),
        ),
      ),
    );
  }
}
