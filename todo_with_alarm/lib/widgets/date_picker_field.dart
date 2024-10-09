// widgets/date_picker_field.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime) onSelectDate;
  final DateTime firstDate = DateTime(2020);
  final DateTime lastDate = DateTime(2030);

  DatePickerField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onSelectDate,
  });

  Future<void> _selectDate(BuildContext context) async {
    final initialDate = selectedDate ?? DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (pickedDate != null) {
      onSelectDate(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            selectedDate == null
                ? '$label을 선택하세요'
                : '$label: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        ElevatedButton(
          onPressed: () => _selectDate(context),
          child: Text('$label 선택'),
        ),
      ],
    );
  }
}