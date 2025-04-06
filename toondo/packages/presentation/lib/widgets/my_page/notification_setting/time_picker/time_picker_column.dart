import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimePickerColumn extends StatelessWidget {
  final List<String> items;
  final Function(String)? onItemSelected;

  const TimePickerColumn({
    super.key,
    required this.items,
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CupertinoPicker(
        itemExtent: 36,
        onSelectedItemChanged: (index) {
          if (onItemSelected != null) {
            onItemSelected!(items[index]);
          }
        },
        children: items.map((item) => Center(child: Text(item))).toList(),
      ),
    );
  }
}
