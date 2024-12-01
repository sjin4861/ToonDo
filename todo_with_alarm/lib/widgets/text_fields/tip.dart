import 'package:flutter/material.dart';

class TipWidget extends StatelessWidget {
  final String title;
  final String description;

  const TipWidget({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color(0xFF78B545),
            fontSize: 10,
            fontFamily: 'Pretendard Variable',
            fontWeight: FontWeight.w700,
            letterSpacing: 0.15,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            description,
            style: TextStyle(
              color: Color(0xBF1C1D1B),
              fontSize: 10,
              fontFamily: 'Pretendard Variable',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.15,
            ),
          ),
        ),
      ],
    );
  }
}
