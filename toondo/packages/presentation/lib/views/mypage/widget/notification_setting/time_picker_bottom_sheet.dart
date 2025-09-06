import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/bottom_sheets/app_bottom_sheet.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/viewmodels/my_page/notification_setting/time_picker_viewmodel.dart';

class TimePickerBottomSheet extends StatelessWidget {
  const TimePickerBottomSheet({super.key});

  static List<String> get _hourItems =>
      List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));

  static List<String> get _minuteItems =>
      List.generate(60, (index) => index.toString().padLeft(2, '0'));

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TimePickerViewModel>();

    return AppBottomSheet(
      fixedHeight: AppDimensions.timePickerBottomSheetHeight,
      isScrollable: false,
      body: Column(
        children: [
          Text(
            '시간 설정',
            style: AppTypography.h1Bold.copyWith(color: AppColors.status100),
          ),
          SizedBox(height: AppSpacing.v32),
          _buildPickerRow(viewModel),
          SizedBox(height: AppSpacing.v40),
          _buildSaveButton(context, viewModel),
          SizedBox(height: AppSpacing.v32),
        ],
      ),
    );
  }

  Widget _buildPickerRow(TimePickerViewModel viewModel) {
    return SizedBox(
      height: 170.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0.h,
            child: Container(
              width: 298.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
              ),
            ),
          ),
          Positioned(
            top: 54.h,
            child: Container(
              width: 298.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: AppColors.green100,
                borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
              ),
            ),
          ),
          Positioned(
            bottom: 0.h,
            child: Container(
              width: 298.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _TimeWheelPicker(
                    items: ['오전', '오후'],
                    selectedItem: viewModel.ampm,
                    onSelected: viewModel.setAmPm,
                    isKoreanAmPm: true,
                  ),
                  SizedBox(width: AppSpacing.h12),
                  _TimeWheelPicker(
                    items: _hourItems,
                    selectedItem: viewModel.hour,
                    onSelected: viewModel.setHour,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.h8),
                    child: Text(
                      ':',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.green500,
                      ),
                    ),
                  ),
                  _TimeWheelPicker(
                    items: _minuteItems,
                    selectedItem: viewModel.minute,
                    onSelected: viewModel.setMinute,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, TimePickerViewModel viewModel) {
    return SizedBox(
      width: AppDimensions.buttonWidthMedium,
      height: AppDimensions.buttonHeight,
      child: OutlinedButton(
        onPressed: () async {
          await viewModel.saveSelectedTime();
          Navigator.pop(context);
        },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
          ),
          side: const BorderSide(color: AppColors.green500),
        ),
        child: Text(
          '저장하기',
          style: AppTypography.h2Bold.copyWith(color: AppColors.green500),
        ),
      ),
    );
  }
}

class _TimeWheelPicker extends StatefulWidget {
  final List<String> items;
  final String selectedItem;
  final ValueChanged<String> onSelected;
  final bool isKoreanAmPm;

  const _TimeWheelPicker({
    required this.items,
    required this.selectedItem,
    required this.onSelected,
    this.isKoreanAmPm = false,
  });

  @override
  State<_TimeWheelPicker> createState() => _TimeWheelPickerState();
}

class _TimeWheelPickerState extends State<_TimeWheelPicker> {
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    final selectedIndex = widget.items.indexOf(widget.selectedItem);
    _controller = FixedExtentScrollController(initialItem: selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      width: 70.w,
      child: ListWheelScrollView.useDelegate(
        controller: _controller,
        itemExtent: 60.h,
        perspective: 0.001,
        diameterRatio: 2.4,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) {
          widget.onSelected(widget.items[index]);
        },
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: widget.items.length,
          builder: (context, index) {
            final isSelected = widget.items[index] == widget.selectedItem;
            return Center(
              child: Text(
                widget.items[index],
                style: TextStyle(
                  fontFamily: 'Pretendard Variable',
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: widget.isKoreanAmPm ? 20.sp : (isSelected ? 36.sp : 24.sp),
                  color: isSelected ? AppColors.green500 : const Color(0xFF8D8E8D),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
