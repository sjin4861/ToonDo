import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool obscureText;
  final bool enabled;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final bool isValid;
  final Widget? suffixIcon;
  final Color? borderColor; // 테두리 색상 추가
  final EdgeInsetsGeometry? contentPadding; // 패딩 설정 추가

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.enabled = true,
    this.controller,
    this.onChanged,
    this.errorText,
    this.isValid = false,
    this.suffixIcon,
    this.borderColor,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    Color effectiveBorderColor = borderColor ??
        (isValid ? Color(0xFF78B545) : Color(0xFFDDDDDD));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF1C1D1B),
            fontSize: 10,
            fontFamily: 'Pretendard Variable',
            fontWeight: FontWeight.w400,
            letterSpacing: 0.15,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 40,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: effectiveBorderColor,
              ),
              borderRadius: BorderRadius.circular(1000),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscureText,
                  onChanged: onChanged,
                  enabled: enabled,
                  decoration: InputDecoration(
                    contentPadding:
                        contentPadding ?? EdgeInsets.symmetric(horizontal: 16),
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: Color(0x3F1C1D1B),
                      fontSize: 12,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.18,
                    ),
                  ),
                  style: TextStyle(
                    color: Color(0xFF1C1D1B),
                    fontSize: 12,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.18,
                  ),
                ),
              ),
              if (suffixIcon != null) suffixIcon!,
            ],
          ),
        ),
        if (errorText != null) ...[
          SizedBox(height: 4),
          Text(
            errorText!,
            style: TextStyle(
              color: Color(0xFFEE0F12),
              fontSize: 10,
              fontFamily: 'Pretendard Variable',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.15,
            ),
          ),
        ],
      ],
    );
  }
}