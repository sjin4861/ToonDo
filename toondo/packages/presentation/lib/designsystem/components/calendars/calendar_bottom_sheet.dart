import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/bottom_sheets/bottom_sheet_drag_indicator.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:table_calendar/table_calendar.dart';

class SelectDateBottomSheet extends StatefulWidget {
  final DateTime initialDate;

  /// 표시용 범위(있으면 시작/끝/사이만 하이라이트)
  final DateTime? rangeStart;
  final DateTime? rangeEnd;

  const SelectDateBottomSheet({
    super.key,
    required this.initialDate,
    this.rangeStart,
    this.rangeEnd,
  });

  @override
  State<SelectDateBottomSheet> createState() => _SelectDateBottomSheetState();
}

class _SelectDateBottomSheetState extends State<SelectDateBottomSheet> {
  late DateTime _focusedDay;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialDate;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isBetween(DateTime d, DateTime s, DateTime e) {
    final day = DateTime(d.year, d.month, d.day);
    final start = DateTime(s.year, s.month, s.day);
    final end = DateTime(e.year, e.month, e.day);
    if (_isSameDay(day, start) || _isSameDay(day, end)) return false;
    return (day.isAfter(start) && day.isBefore(end)) ||
        (day.isAfter(end) && day.isBefore(start));
  }

  bool _isStart(DateTime day) =>
      widget.rangeStart != null && _isSameDay(day, widget.rangeStart!);

  bool _isEnd(DateTime day) =>
      widget.rangeEnd != null && _isSameDay(day, widget.rangeEnd!);

  bool _isInRange(DateTime day) {
    final s = widget.rangeStart;
    final e = widget.rangeEnd;
    if (s == null || e == null) return false;
    return _isBetween(day, s, e);
  }

  void _goPrevMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
    });
  }

  void _goNextMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
    });
  }

  void _closeOnce(DateTime result) {
    if (_closing) return;
    _closing = true;
    Future.microtask(() {
      if (!mounted) return;
      Navigator.of(context).pop(result); // DateTime 반환
    });
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
              const BottomSheetDragIndicator(isGrey: true),
              SizedBox(height: 16.h),

              TableCalendar(
                locale: 'ko_KR',
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2035, 12, 31),
                focusedDay: _focusedDay,
                sixWeekMonthsEnforced: true,
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.sunday,

                // 선택/오늘 하이라이트 완전 비활성화
                rangeSelectionMode: RangeSelectionMode.disabled,
                selectedDayPredicate: (_) => false,

                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  titleTextFormatter: (date, locale) => '',
                  leftChevronVisible: false,
                  rightChevronVisible: false,
                  headerPadding: EdgeInsets.only(bottom: AppSpacing.v12),
                ),

                calendarBuilders: CalendarBuilders(
                  headerTitleBuilder: (context, day) {
                    final year = DateFormat('yyyy', 'ko_KR').format(day);
                    final month = DateFormat('M월', 'ko_KR').format(day);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: AppSpacing.h12),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                year,
                                style: AppTypography.h1Regular.copyWith(
                                  color: AppColors.status100.withOpacity(0.2),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              month,
                              style: AppTypography.h1Bold.copyWith(
                                color: AppColors.status100,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: _goPrevMonth,
                              icon: const Icon(Icons.chevron_left,
                                  color: AppColors.bottomIconColor),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              splashRadius: 20,
                            ),
                            IconButton(
                              onPressed: _goNextMonth,
                              icon: const Icon(Icons.chevron_right,
                                  color: AppColors.bottomIconColor),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              splashRadius: 20,
                            ),
                          ],
                        ),
                      ],
                    );
                  },

                  // 우리 스타일: start/end 원형 + within-range 초록 텍스트 + 나머지 기본
                  defaultBuilder: (context, day, focusedDay) {
                    final isStart = _isStart(day);
                    final isEnd = _isEnd(day);
                    final inBetween = _isInRange(day);

                    final base = AppTypography.h1Regular.copyWith(
                      color: AppColors.status100,
                    );

                    if (isStart || isEnd) {
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.green500.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${day.day}',
                          style: AppTypography.h1Bold.copyWith(
                            color: AppColors.green500,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      );
                    }

                    if (inBetween) {
                      return Center(
                        child: Text(
                          '${day.day}',
                          style: base.copyWith(color: AppColors.green500),
                        ),
                      );
                    }

                    return Center(child: Text('${day.day}', style: base));
                  },

                  outsideBuilder: (context, day, focusedDay) => SizedBox.expand(
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: AppTypography.h1Regular.copyWith(
                          color: AppColors.status100.withOpacity(0.2),
                        ),
                        strutStyle: const StrutStyle(
                            height: 1.0, forceStrutHeight: true, leading: 0),
                        textHeightBehavior: const TextHeightBehavior(
                          applyHeightToFirstAscent: false,
                          applyHeightToLastDescent: false,
                        ),
                      ),
                    ),
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
                  isTodayHighlighted: false, // 오늘 하이라이트 끔
                  defaultTextStyle: AppTypography.h1Regular.copyWith(
                    color: AppColors.status100,
                  ),
                  weekendTextStyle: AppTypography.h1Regular.copyWith(
                    color: AppColors.status100,
                  ),
                  outsideTextStyle: AppTypography.h1Regular.copyWith(
                    color: AppColors.status100.withOpacity(0.2),
                  ),
                  cellAlignment: Alignment.center,
                  cellPadding: EdgeInsets.zero,

                  // 선택/오늘 데코 제거 (안 쓰지만 안전하게 투명)
                  todayDecoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: AppTypography.h1Regular.copyWith(
                    color: AppColors.status100,
                  ),
                ),

                // 탭 시: DateTime 반환하고 닫기
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() => _focusedDay = focusedDay);
                  _closeOnce(selectedDay);
                },
              ),

              SizedBox(height: AppSpacing.v24),
            ],
          ),
        ),
      ),
    );
  }
}
