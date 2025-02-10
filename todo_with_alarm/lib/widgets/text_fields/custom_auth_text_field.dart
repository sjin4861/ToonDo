import 'package:flutter/material.dart';

class CustomAuthTextField extends StatelessWidget {
  final Key? key;
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String? errorText;
  final bool isValid;
  final bool readOnly;
  final bool obscureText;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;

  const CustomAuthTextField({
    this.key,
    required this.label,
    this.hintText,
    required this.controller,
    this.onChanged,
    this.errorText,
    this.isValid = true,
    this.readOnly = false,
    this.obscureText = false,
    this.suffixIcon,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, child) {
            final effectiveBorderColor =
                value.text.isNotEmpty ? Color(0xFF78B545) : Color(0xFFDDDDDD);
            return TextField(
              readOnly: readOnly,
              controller: controller,
              obscureText: obscureText,
              onChanged: onChanged,
              decoration: InputDecoration(
                contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 16),
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Color(0xFFB2B2B2),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.18,
                  fontFamily: 'Pretendard Variable',
                ),
                suffixIcon: suffixIcon,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1000),
                  borderSide: BorderSide(color: effectiveBorderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1000),
                  borderSide: BorderSide(color: effectiveBorderColor),
                ),
                errorText: errorText,
              ),
              keyboardType: TextInputType.text,
            );
          },
        ),
      ],
    );
  }
}
