import 'package:flutter/material.dart';
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
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 16,
            right: 16,
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
                  titleTextStyle: TextStyle(
                    color: Color(0xFF535353),
                    fontSize: 20,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w700,
                  ),
                  leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xFF535353)),
                  rightChevronIcon: Icon(Icons.chevron_right, color: Color(0xFF535353)),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(
                    color: Color(0x4C3C3C43),
                    fontSize: 13,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w600,
                  ),
                  weekdayStyle: TextStyle(
                    color: Color(0x4C3C3C43),
                    fontSize: 13,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w400,
                  ),
                  weekendTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w400,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Color(0xFF78B545),
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w700,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Color(0x1F78B545),
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(
                    color: Color(0xFF78B545),
                    fontSize: 20,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.w700,
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
