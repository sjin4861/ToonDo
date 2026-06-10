import 'package:domain/entities/recurrence_rule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/bottom_sheets/bottom_sheet_drag_indicator.dart';
import 'package:presentation/designsystem/components/buttons/double_action_buttons.dart';
import 'package:presentation/designsystem/components/calendars/calendar_bottom_sheet.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';

enum _Mode { none, daily, weekly, monthly }

enum _EndMode { never, onDate, afterCount }

class RecurrenceBottomSheet extends StatefulWidget {
  final RecurrenceRule? initial;
  final DateTime? seriesStartDate;
  /// false면 "안 함" 칩 숨김 + 초기 모드 매일 강제 (루틴 입력 시 사용)
  final bool allowNone;

  const RecurrenceBottomSheet({
    super.key,
    this.initial,
    this.seriesStartDate,
    this.allowNone = true,
  });

  @override
  State<RecurrenceBottomSheet> createState() => _RecurrenceBottomSheetState();
}

class _RecurrenceBottomSheetState extends State<RecurrenceBottomSheet> {
  late _Mode _mode;
  int _interval = 1;
  final Set<int> _weekdays = {};
  int _monthDay = 1;
  _EndMode _endMode = _EndMode.never;
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  int _count = 10;

  @override
  void initState() {
    super.initState();
    final r = widget.initial;
    if (r == null) {
      _mode = widget.allowNone ? _Mode.none : _Mode.daily;
      final defaultDay = widget.seriesStartDate?.weekday;
      if (defaultDay != null) _weekdays.add(defaultDay);
      _monthDay = widget.seriesStartDate?.day ?? 1;
    } else {
      _mode = switch (r.frequency) {
        RecurrenceFrequency.daily => _Mode.daily,
        RecurrenceFrequency.weekly => _Mode.weekly,
        RecurrenceFrequency.monthly => _Mode.monthly,
        RecurrenceFrequency.yearly => _Mode.monthly, // 매년 옵션 제거됨 — 매달로 폴백
      };
      _interval = r.interval;
      _weekdays.addAll(r.byWeekdays);
      _monthDay = r.byMonthDay ?? widget.seriesStartDate?.day ?? 1;
      switch (r.end) {
        case EndNever():
          _endMode = _EndMode.never;
        case EndOnDate(date: final d):
          _endMode = _EndMode.onDate;
          _endDate = d;
        case EndAfterCount(count: final c):
          _endMode = _EndMode.afterCount;
          _count = c;
      }
    }
  }

  RecurrenceRule? _build() {
    if (_mode == _Mode.none) return null;
    final frequency = switch (_mode) {
      _Mode.daily => RecurrenceFrequency.daily,
      _Mode.weekly => RecurrenceFrequency.weekly,
      _Mode.monthly => RecurrenceFrequency.monthly,
      _Mode.none => RecurrenceFrequency.daily,
    };
    final end = switch (_endMode) {
      _EndMode.never => const EndNever(),
      _EndMode.onDate => EndOnDate(_endDate),
      _EndMode.afterCount => EndAfterCount(_count),
    };
    return RecurrenceRule(
      frequency: frequency,
      interval: _interval.clamp(1, 365),
      byWeekdays: _mode == _Mode.weekly
          ? (_weekdays.toList()..sort())
          : const [],
      byMonthDay: _mode == _Mode.monthly ? _monthDay : null,
      end: end,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.78,
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.bottomSheetTopRadius),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: AppSpacing.v22),
          const BottomSheetDragIndicator(),
          SizedBox(height: AppSpacing.v30),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.h20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Text('반복 설정', style: AppTypography.h2Bold),
                    SizedBox(height: AppSpacing.v20),
                    _frequencySection(),
                    if (_mode != _Mode.none) ...[
                      SizedBox(height: AppSpacing.v24),
                      _intervalSection(),
                    ],
                    if (_mode == _Mode.weekly) ...[
                      SizedBox(height: AppSpacing.v24),
                      _weekdaySection(),
                    ],
                    if (_mode == _Mode.monthly) ...[
                      SizedBox(height: AppSpacing.v24),
                      _monthDaySection(),
                    ],
                    if (_mode != _Mode.none) ...[
                      SizedBox(height: AppSpacing.v24),
                      _endSection(),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.h20,
                AppSpacing.v24,
                AppSpacing.h20,
                AppSpacing.v24,
              ),
              child: DoubleActionButtons(
                backText: '취소',
                nextText: '적용',
                onBack: () =>
                    Navigator.of(context).pop<RecurrenceRule?>(null),
                onNext: _isValid()
                    ? () =>
                        Navigator.of(context).pop<RecurrenceRule?>(_build())
                    : null,
                isNextEnabled: _isValid(),
              ),
            ),
        ],
      ),
    );
  }

  bool _isValid() {
    if (_mode == _Mode.weekly && _weekdays.isEmpty) return false;
    if (_endMode == _EndMode.afterCount && _count < 1) return false;
    return true;
  }

  Widget _frequencySection() {
    return _section(
      title: '주기',
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: AppSpacing.h8,
        runSpacing: AppSpacing.v8,
        children: [
          if (widget.allowNone)
            _choiceChip('안 함', _mode == _Mode.none, () {
              setState(() => _mode = _Mode.none);
            }),
          _choiceChip('일', _mode == _Mode.daily, () {
            setState(() => _mode = _Mode.daily);
          }),
          _choiceChip('주', _mode == _Mode.weekly, () {
            setState(() => _mode = _Mode.weekly);
          }),
          _choiceChip('달', _mode == _Mode.monthly, () {
            setState(() => _mode = _Mode.monthly);
          }),
        ],
      ),
    );
  }

  Widget _intervalSection() {
    final unit = switch (_mode) {
      _Mode.daily => '일',
      _Mode.weekly => '주',
      _Mode.monthly => '달',
      _Mode.none => '',
    };
    return _section(
      title: '간격',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('매', style: AppTypography.body2Regular),
          SizedBox(width: AppSpacing.h8),
          _stepper(_interval, (v) => setState(() => _interval = v)),
          SizedBox(width: AppSpacing.h8),
          Text(unit, style: AppTypography.body2Regular),
        ],
      ),
    );
  }

  Widget _weekdaySection() {
    const labels = ['월', '화', '수', '목', '금', '토', '일'];
    return _section(
      title: '요일',
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: AppSpacing.h8,
        children: List.generate(7, (i) {
          final weekday = i + 1;
          final selected = _weekdays.contains(weekday);
          return _choiceChip(labels[i], selected, () {
            setState(() {
              if (selected) {
                _weekdays.remove(weekday);
              } else {
                _weekdays.add(weekday);
              }
            });
          });
        }),
      ),
    );
  }

  Widget _monthDaySection() {
    return _section(
      title: '일자',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _stepper(_monthDay, (v) {
            if (v < 1 || v > 31) return;
            setState(() => _monthDay = v);
          }),
          SizedBox(width: AppSpacing.h8),
          Text('일', style: AppTypography.body2Regular),
        ],
      ),
    );
  }

  Widget _endSection() {
    return _section(
      title: '종료',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _radioRow('계속 반복', _endMode == _EndMode.never, () {
            setState(() => _endMode = _EndMode.never);
          }),
          SizedBox(height: AppSpacing.v8),
          _radioRow(
            '특정 날짜에 종료 (${DateFormat('yyyy. M. d.').format(_endDate)})',
            _endMode == _EndMode.onDate,
            () async {
              setState(() => _endMode = _EndMode.onDate);
              final picked = await showModalBottomSheet<DateTime>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => SelectDateBottomSheet(
                  initialDate: _endDate,
                  rangeStart: _endDate,
                  rangeEnd: _endDate,
                ),
              );
              if (!mounted) return;
              if (picked != null) setState(() => _endDate = picked);
            },
          ),
          SizedBox(height: AppSpacing.v8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _radioRow('횟수 제한', _endMode == _EndMode.afterCount, () {
                setState(() => _endMode = _EndMode.afterCount);
              }),
              SizedBox(width: AppSpacing.h16),
              if (_endMode == _EndMode.afterCount)
                _stepper(_count, (v) {
                  if (v < 1) return;
                  setState(() => _count = v);
                }),
              if (_endMode == _EndMode.afterCount) ...[
                SizedBox(width: AppSpacing.h8),
                Text('회', style: AppTypography.body2Regular),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title,
            style: AppTypography.caption1Regular
                .copyWith(color: AppColors.status100_75)),
        SizedBox(height: AppSpacing.v8),
        child,
      ],
    );
  }

  Widget _choiceChip(String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.green500 : AppColors.green100,
          borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
        ),
        child: Text(
          label,
          style: AppTypography.caption1Medium.copyWith(
            color: selected ? Colors.white : AppColors.status100,
          ),
        ),
      ),
    );
  }

  Widget _stepper(int value, ValueChanged<int> onChange) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => onChange(value - 1),
            icon: const Icon(Icons.remove, size: 16),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text('$value', style: AppTypography.body2Medium),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => onChange(value + 1),
            icon: const Icon(Icons.add, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _radioRow(String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: selected ? AppColors.green500 : AppColors.status100_50,
            size: 18,
          ),
          SizedBox(width: AppSpacing.h8),
          Text(label, style: AppTypography.body2Regular),
        ],
      ),
    );
  }
}
