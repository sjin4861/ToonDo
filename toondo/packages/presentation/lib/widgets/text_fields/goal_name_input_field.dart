import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:provider/provider.dart';
import 'package:presentation/viewmodels/goal/goal_input_viewmodel.dart';
import 'package:presentation/widgets/goal/input/goal_icon_bottom_sheet.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoalNameInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;

  const GoalNameInputField({
    super.key,
    required this.controller,
    this.errorText,
  });

  @override
  State<GoalNameInputField> createState() => _GoalNameInputFieldState();
}

class _GoalNameInputFieldState extends State<GoalNameInputField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '목표 이름',
          style: AppTypography.caption1Regular.copyWith(
            color: AppColors.status100,
          ),
        ),
        SizedBox(height: AppSpacing.spacing8),
        Row(
          children: [
            // 아이콘 선택 버튼
            Consumer<GoalInputViewModel>(
              builder:
                  (context, viewModel, child) => GestureDetector(
                    onTap: () async {
                      // 아이콘 선택 BottomSheet 열기
                      String? selectedIcon = await showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => GoalIconBottomSheet(),
                      );

                      if (selectedIcon != null) {
                        viewModel.selectIcon(selectedIcon);
                      }
                    },
                    child: Container(
                      width: 40, // 작은 동그라미 크기
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              viewModel.selectedIcon != null
                                  ? AppColors.green500
                                  : AppColors.borderUnselected,
                          width: 1,
                        ),
                        color: Colors.white,
                      ),
                      child:
                          viewModel.selectedIcon != null
                              ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  viewModel.selectedIcon!,
                                  width: AppDimensions.iconSize24,
                                  height: AppDimensions.iconSize24,
                                  fit: BoxFit.contain,
                                ),
                              )
                              : const Icon(
                                Icons.add,
                                color: AppColors.green500,
                                size: AppDimensions.iconSize16,
                              ),
                    ),
                  ),
            ),
            const SizedBox(width: AppSpacing.spacing8),
            Expanded(
              child: SizedBox(
                height: AppDimensions.inputFieldHeight,
                child: TextFormField(
                  controller: widget.controller,
                  cursorColor: AppColors.green500,
                  style: AppTypography.body2Regular.copyWith(
                    color: AppColors.status100,
                  ),
                  decoration: InputDecoration(
                    hintText: '목표 이름을 입력해주세요.',
                    hintStyle: AppTypography.body2Regular.copyWith(
                      color: AppColors.status100_25,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.spacing16,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusPill,
                      ),
                      borderSide: BorderSide(
                        width: 1.0,
                        color:
                            widget.controller.text.isNotEmpty
                                ? AppColors.green500
                                : AppColors.borderUnselected,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusPill,
                      ),
                      borderSide: BorderSide(
                        color:
                            widget.controller.text.isNotEmpty
                                ? AppColors.green500
                                : AppColors.borderUnselected,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (widget.errorText != null) ...[
          SizedBox(height: AppSpacing.spacing4),
          Text(
            widget.errorText!,
            style: AppTypography.caption1Regular.copyWith(
              color: AppColors.red500,
            ),
          ),
        ],
      ],
    );
  }
}
