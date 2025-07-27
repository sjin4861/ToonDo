import 'package:flutter/material.dart';
import 'package:presentation/widgets/bottom_sheet/custom_bottom_sheet.dart';

class CarrierSelectBottomSheet extends StatelessWidget {
  final void Function(String) onSelected;

  const CarrierSelectBottomSheet({
    super.key,
    required this.onSelected,
  });

  static final List<String> carriers = [
    'SKT',
    'KT',
    'LG U+',
    'SKT 알뜰폰',
    'KT 알뜰폰',
    'LG U+ 알뜰폰',
  ];

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: '통신사를 선택해주세요',
      initialSize: 0.8,
      maxSize: 0.8,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: carriers
              .map((carrier) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                onSelected(carrier);
              },
              child: Text(
                carrier,
                style: TextStyle(
                  fontSize: 16,
                  color: const Color(0xFF1C1D1B),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Pretendard Variable',
                ),
              ),
            ),
          ))
              .toList(),
        ),
      ),
      buttons: const [],
    );
  }
}
