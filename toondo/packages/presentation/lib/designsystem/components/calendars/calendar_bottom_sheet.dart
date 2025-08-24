import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:table_calendar/table_calendar.dart';

class SelectDateBottomSheet extends StatefulWidget {
  final DateTime initialDate;

  const SelectDateBottomSheet({super.key, required this.initialDate});

  @override
  _SelectDateBottomSheetState createState() => _SelectDateBottomSheetState();
}

class _SelectDateBottomSheetState extends State<SelectDateBottomSheet> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialDate;
    _selectedDay = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.status0,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.borderRadius16),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: AppSpacing.v24,
            left: AppSpacing.h16,
            right: AppSpacing.h16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  titleTextStyle: AppTypography.h1Bold.copyWith(
                    color: AppColors.bottomIconColor,
                  ),
                  leftChevronIcon: const Icon(
                    Icons.chevron_left,
                    color: AppColors.bottomIconColor,
                  ),
                  rightChevronIcon: const Icon(
                    Icons.chevron_right,
                    color: AppColors.bottomIconColor,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: AppTypography.body2SemiBold.copyWith(
                    color: AppColors.status100.withOpacity(0.3),
                  ),
                  weekdayStyle: AppTypography.body2SemiBold.copyWith(
                    color: AppColors.status100.withOpacity(0.3),
                  ),
                ),
                calendarStyle: CalendarStyle(
                  defaultTextStyle: AppTypography.h1Regular.copyWith(
                    color: AppColors.status100,
                  ),
                  weekendTextStyle: AppTypography.h1Regular.copyWith(
                    color: AppColors.status100,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: AppColors.green500,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: AppTypography.h1Bold.copyWith(
                    color: AppColors.status0,
                  ),
                  todayDecoration: BoxDecoration(
                    color: AppColors.green500.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: AppTypography.h1Bold.copyWith(
                    color: AppColors.green500,
                  ),
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  Navigator.pop(context, selectedDay);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
