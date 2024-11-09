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
          padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isWeeklyView
                    ? DateFormat('M월').format(currentDate)
                    : DateFormat('yyyy년 M월').format(currentDate),
                style: TextStyle(
                  color: Color(0xFF111111),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.24,
                  fontFamily: 'Pretendard Variable',
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, color: Color(0xFF1C1D1B)),
                    onPressed: _goToPreviousPeriod,
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right, color: Color(0xFF1C1D1B)),
                    onPressed: _goToNextPeriod,
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: _toggleCalendarView,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: ShapeDecoration(
                        color: Color(0xFFE4F0D9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        isWeeklyView ? '주' : '월',
                        style: TextStyle(
                          color: Color(0xFF1C1D1B),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.15,
                          fontFamily: 'Pretendard Variable',
                        ),
                      ),
                    ),
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
    DateTime weekStartDate =
        currentDate.subtract(Duration(days: currentDate.weekday % 7));
    List<DateTime> weekDates =
        List.generate(7, (index) => weekStartDate.add(Duration(days: index)));
    List<String> weekDays = ['일', '월', '화', '수', '목', '금', '토'];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // 요일 및 날짜 표시
          Row(
            children: List.generate(7, (index) {
              DateTime date = weekDates[index];
              String dayLabel = weekDays[index];
              bool isSelected = DateFormat('yyyy-MM-dd').format(date) ==
                  DateFormat('yyyy-MM-dd').format(widget.selectedDate);
              bool isCurrentMonth = date.month == currentDate.month;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    widget.onDateSelected(date);
                  },
                  child: Column(
                    children: [
                      // 요일
                      Text(
                        dayLabel,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF1C1D1B),
                          fontSize: 10,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: index == (DateTime.now().weekday % 7)
                              ? FontWeight.w700
                              : FontWeight.w400,
                          letterSpacing: 0.15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // 날짜
                      Container(
                        width: 32,
                        height: 32,
                        decoration: ShapeDecoration(
                          color: isSelected
                              ? Color(0xFF78B545)
                              : isCurrentMonth
                                  ? Color(0x7FE4F0D9)
                                  : Color(0x7FEEEEEE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1000),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            date.day.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : isCurrentMonth
                                      ? Color(0xFF535353)
                                      : Color(0xBF535353),
                              fontSize: 10,
                              fontFamily: 'Pretendard Variable',
                              fontWeight:
                                  isSelected ? FontWeight.w600 : FontWeight.w400,
                              letterSpacing: 0.15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
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
    DateTime calendarStartDate =
        firstDayOfMonth.subtract(Duration(days: weekdayOfFirstDay));

    // 총 표시될 주 수 계산
    int totalWeeks =
        ((lastDayOfMonth.difference(calendarStartDate).inDays + 1) / 7).ceil();

    List<String> weekDays = ['일', '월', '화', '수', '목', '금', '토'];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // 요일 표시
          Row(
            children: weekDays.map((dayLabel) {
              return Expanded(
                child: Center(
                  child: Text(
                    dayLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1C1D1B),
                      fontSize: 10,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.15,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          // 날짜 표시
          Column(
            children: List.generate(totalWeeks, (weekIndex) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // 날짜들 사이에 공간을 추가
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
                        width: 32, // 날짜 셀의 너비를 고정
                        height: 32,
                        margin: EdgeInsets.symmetric(horizontal: 2.0), // 날짜들 사이에 마진 추가
                        decoration: ShapeDecoration(
                          color: isSelected
                              ? Color(0xFF78B545)
                              : isCurrentMonth
                                  ? Color(0x7FE4F0D9)
                                  : Color(0x7FEEEEEE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1000),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            date.day.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : isCurrentMonth
                                      ? Color(0xFF535353)
                                      : Color(0xBF535353),
                              fontSize: 10,
                              fontFamily: 'Pretendard Variable',
                              fontWeight:
                                  isSelected ? FontWeight.w600 : FontWeight.w400,
                              letterSpacing: 0.15,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );
            }),
          ),  
        ],
      ),
    );
  }
}