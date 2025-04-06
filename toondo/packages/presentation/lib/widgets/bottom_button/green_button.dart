import 'package:flutter/material.dart';

// NOTE 기본 녹색 바텀 버튼. 버튼명 뭐라고 할까요
class GreenButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const GreenButton({super.key, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF78B545),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            fontFamily: 'Pretendard Variable',
          ),
        ),
      ),
    );
  }
}