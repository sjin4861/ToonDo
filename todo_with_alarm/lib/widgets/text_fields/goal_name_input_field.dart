import 'package:flutter/material.dart';

class GoalNameInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  GoalNameInputField({required this.controller, this.errorText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('목표 이름', style: _textStyle(Color(0xFF1C1D1B), 10, FontWeight.w400)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: '목표 이름을 입력해주세요.',
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(1000),
              borderSide: BorderSide(
                color: controller.text.isNotEmpty ? Color(0xFF78B545) : Color(0xFFDDDDDD),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(1000),
              borderSide: BorderSide(
                color: controller.text.isNotEmpty ? Color(0xFF78B545) : Color(0xFFDDDDDD),
                width: 2.0,
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          SizedBox(height: 4),
          Text(errorText!, style: _textStyle(Color(0xFFEE0F12), 10, FontWeight.w400)),
        ],
      ],
    );
  }

  TextStyle _textStyle(Color color, double fontSize, FontWeight fontWeight) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: 'Pretendard Variable',
      fontWeight: fontWeight,
      letterSpacing: 0.15,
    );
  }
}
