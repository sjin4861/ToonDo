// widgets/Calendar.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const Calendar({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  bool isWeeklyView = true; // 주간/월간 뷰 전환 상태
  DateTime currentDate = DateTime.now();

  void _toggleCalendarView() {
    setState(() {
      isWeeklyView = !isWeeklyView;
    });
  }

  void _goToPreviousPeriod() {
    setState(() {
      if (isWeeklyView) {
        currentDate = currentDate.subtract(Duration(days: 7));
      } else {
        currentDate = DateTime(currentDate.year, currentDate.month - 1, 1);
      }
    });
  }

  void _goToNextPeriod() {
    setState(() {
      if (isWeeklyView) {
        currentDate = currentDate.add(Duration(days: 7));
      } else {
        currentDate = DateTime(currentDate.year, currentDate.month + 1, 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 상단 바: 월 표시 및 뷰 전환 버튼
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isWeeklyView
                    ? DateFormat('M월').format(currentDate)
                    : DateFormat('yyyy년 M월').format(currentDate),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left),
                    onPressed: _goToPreviousPeriod,
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right),
                    onPressed: _goToNextPeriod,
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _toggleCalendarView,
                    child: Text(isWeeklyView ? '주' : '월'),
                  ),
                ],
              ),
            ],
          ),
        ),
        isWeeklyView ? _buildWeeklyCalendar() : _buildMonthlyCalendar(),
      ],
    );
  }

  // 주간 캘린더 빌드
  Widget _buildWeeklyCalendar() {
    DateTime weekStartDate = currentDate.subtract(Duration(days: currentDate.weekday - 1));
    List<DateTime> weekDates = List.generate(7, (index) => weekStartDate.add(Duration(days: index)));
    List<String> weekDays = ['월', '화', '수', '목', '금', '토', '일'];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (index) {
          DateTime date = weekDates[index];
          String dayLabel = weekDays[index];
          bool isSelected = DateFormat('yyyy-MM-dd').format(date) ==
              DateFormat('yyyy-MM-dd').format(widget.selectedDate);

          return GestureDetector(
            onTap: () {
              widget.onDateSelected(date);
            },
            child: Column(
              children: [
                Text(
                  dayLabel,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.grey[400] : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // 월간 캘린더 빌드
  Widget _buildMonthlyCalendar() {
    int year = currentDate.year;
    int month = currentDate.month;

    // 해당 월의 첫 번째 날과 마지막 날
    DateTime firstDayOfMonth = DateTime(year, month, 1);
    DateTime lastDayOfMonth = DateTime(year, month + 1, 0);

    // 캘린더에 표시될 첫 번째 날짜 (주 시작 요일에 맞게 조정)
    int weekdayOfFirstDay = firstDayOfMonth.weekday % 7;
    DateTime calendarStartDate = firstDayOfMonth.subtract(Duration(days: weekdayOfFirstDay));

    // 총 표시될 주 수 계산
    int totalWeeks = ((lastDayOfMonth.difference(calendarStartDate).inDays + 1) / 7).ceil();

    return Column(
      children: List.generate(totalWeeks, (weekIndex) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (dayIndex) {
            int daysToAdd = weekIndex * 7 + dayIndex;
            DateTime date = calendarStartDate.add(Duration(days: daysToAdd));
            bool isCurrentMonth = date.month == month;
            bool isSelected = DateFormat('yyyy-MM-dd').format(date) ==
                DateFormat('yyyy-MM-dd').format(widget.selectedDate);

            return GestureDetector(
              onTap: () {
                widget.onDateSelected(date);
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blueAccent
                      : isCurrentMonth
                          ? Colors.grey[300]
                          : Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: isCurrentMonth ? Colors.black : Colors.grey,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}