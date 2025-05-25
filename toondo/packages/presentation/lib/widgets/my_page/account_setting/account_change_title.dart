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
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;
    final postPosition = _getPostPosition(value);

    return Text(
      '$value$postPosition 입력해주세요',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: textColor,
        fontFamily: 'Pretendard Variable',
      ),
    );
  }
}
