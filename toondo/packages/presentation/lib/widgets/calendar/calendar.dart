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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                isWeeklyView
                    ? DateFormat('M월').format(currentDate)
                    : DateFormat('yyyy년 M월').format(currentDate),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Pretendard Variable',
                  fontSize: 16,
                  letterSpacing: 0.15,
                ),
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
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: ShapeDecoration(
                      color: Color(0xFFE4F0D9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      isWeeklyView ? '주' : '월',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Pretendard Variable',
                        fontSize: 10,
                        letterSpacing: 0.15,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        isWeeklyView ? _buildWeeklyCalendar() : _buildMonthlyCalendar(),
      ],
    );
  }

  // 주간 캘린더 빌드
  Widget _buildWeeklyCalendar() {
    DateTime weekStartDate = currentDate.subtract(
      Duration(days: currentDate.weekday % 7),
    );
    List<DateTime> weekDates = List.generate(
      7,
      (index) => weekStartDate.add(Duration(days: index)),
    );
    List<String> weekDays = ['일', '월', '화', '수', '목', '금', '토'];

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;
        if (details.primaryVelocity! < 0) {
          _goToNextPeriod();
        } else if (details.primaryVelocity! > 0) {
          _goToPreviousPeriod();
        }
      },
      child: Column(
        children: [
          // 요일 라벨
          Row(
            children: List.generate(7, (index) {
              String dayLabel = weekDays[index];
              int todayIndex = DateTime.now().weekday % 7;

              return Expanded(
                child: Center(
                  child: Text(
                    dayLabel,
                    style: TextStyle(
                      color: const Color(0xFF1C1D1B),
                      fontSize: 10,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: index == todayIndex ? FontWeight.w700 : FontWeight.w400,
                      letterSpacing: 0.15,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 4),
          // 날짜 셀
          Row(
            children: List.generate(7, (index) {
              DateTime date = weekDates[index];
              bool isSelected =
                  DateFormat('yyyy-MM-dd').format(date) ==
                  DateFormat('yyyy-MM-dd').format(widget.selectedDate);
              bool isCurrentMonth = date.month == currentDate.month;

              return Expanded(
                child: GestureDetector(
                  onTap: () => widget.onDateSelected(date),
                  child: Center(
                    // <-- 핵심: 내부 정렬은 Center로
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? const Color(0xFF78B545)
                                : isCurrentMonth
                                ? const Color(0x7FE4F0D9)
                                : const Color(0x7FEEEEEE),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      child: Center(
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            color:
                                isSelected
                                    ? Colors.white
                                    : isCurrentMonth
                                    ? const Color(0xFF535353)
                                    : const Color(0xBF535353),
                            fontSize: 10,
                            fontFamily: 'Pretendard Variable',
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w400,
                            letterSpacing: 0.15,
                          ),
                        ),
                      ),
                    ),
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

    DateTime firstDayOfMonth = DateTime(year, month, 1);
    DateTime lastDayOfMonth = DateTime(year, month + 1, 0);
    int weekdayOfFirstDay = firstDayOfMonth.weekday % 7;

    DateTime calendarStartDate = firstDayOfMonth.subtract(
      Duration(days: weekdayOfFirstDay),
    );

    int totalWeeks =
        ((lastDayOfMonth.difference(calendarStartDate).inDays + 1) / 7).ceil();

    List<String> weekDays = ['일', '월', '화', '수', '목', '금', '토'];

    return Column(
      children: [
        // 요일 라벨
        Row(
          children:
              weekDays.map((label) {
                return Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: const TextStyle(
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
        // 날짜 셀
        Column(
          children: List.generate(totalWeeks, (weekIndex) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: List.generate(7, (dayIndex) {
                  int daysToAdd = weekIndex * 7 + dayIndex;
                  DateTime date = calendarStartDate.add(
                    Duration(days: daysToAdd),
                  );
                  bool isCurrentMonth = date.month == month;
                  bool isSelected =
                      DateFormat('yyyy-MM-dd').format(date) ==
                      DateFormat('yyyy-MM-dd').format(widget.selectedDate);

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => widget.onDateSelected(date),
                      child: Center(
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? const Color(0xFF78B545)
                                    : isCurrentMonth
                                    ? const Color(0x7FE4F0D9)
                                    : const Color(0x7FEEEEEE),
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          child: Center(
                            child: Text(
                              '${date.day}',
                              style: TextStyle(
                                color:
                                    isSelected
                                        ? Colors.white
                                        : isCurrentMonth
                                        ? const Color(0xFF535353)
                                        : const Color(0xBF535353),
                                fontSize: 10,
                                fontFamily: 'Pretendard Variable',
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                letterSpacing: 0.15,
                              ),
                            ),
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
    );
  }
}
