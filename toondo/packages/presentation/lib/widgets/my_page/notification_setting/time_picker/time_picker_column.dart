import 'package:flutter/cupertino.dart';

class TimePickerColumn extends StatelessWidget {
  final List<String> items;
  final String? initialItem;
  final Function(String)? onItemSelected;

  const TimePickerColumn({
    super.key,
    required this.items,
    this.initialItem,
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final initialIndex =
    initialItem != null ? items.indexOf(initialItem!) : 0;

    return Expanded(
      child: CupertinoPicker(
        itemExtent: 36,
        scrollController: FixedExtentScrollController(initialItem: initialIndex),
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
