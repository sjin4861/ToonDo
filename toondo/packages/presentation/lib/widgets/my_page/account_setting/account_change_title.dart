import 'package:flutter/material.dart';

class AccountChangeTitle extends StatelessWidget {
  final String value;

  const AccountChangeTitle({super.key, required this.value});

  String _getPostPosition(String word) {
    final lastChar = word.characters.last;
    final hasBatchim = _hasBatchim(lastChar);
    return hasBatchim ? '을' : '를';
  }

  bool _hasBatchim(String char) {
    final codeUnit = char.codeUnitAt(0);
    if (codeUnit < 0xAC00 || codeUnit > 0xD7A3) return false;
    return (codeUnit - 0xAC00) % 28 != 0;
  }

  @override
  Widget build(BuildContext context) {
    final postPosition = _getPostPosition(value);

    return Text(
      '$value$postPosition 입력해주세요',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF78B545),
        fontFamily: 'Pretendard Variable',
        letterSpacing: 1.5,
      ),
    );
  }
}
