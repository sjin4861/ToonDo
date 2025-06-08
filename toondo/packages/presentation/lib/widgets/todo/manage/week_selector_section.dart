import 'package:flutter/material.dart';
import 'package:presentation/widgets/calendar/calendar.dart';

class WeekSelectorSection extends StatelessWidget {
  final DateTime selectedDate;
  final void Function(DateTime) onDateSelected;

  const WeekSelectorSection({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Calendar(
        selectedDate: selectedDate,
        onDateSelected: onDateSelected,
    );
  }
}
