import 'package:flutter/material.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';

class AppInputField extends StatefulWidget {
  final String label;
  final String? hintText;
  final String? errorText;
  final TextEditingController controller;
  final bool obscureText;
  final bool showToggleVisibility;
  final VoidCallback? onToggleVisibility;
  final bool isEnabled;

  const AppInputField({
    super.key,
    required this.label,
    this.hintText,
    this.errorText,
    required this.controller,
    this.obscureText = false,
    this.showToggleVisibility = false,
    this.onToggleVisibility,
    this.isEnabled = true,
  });

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;

    widget.controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  OutlineInputBorder _getBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
      borderSide: BorderSide(color: color, width: 1),
    );
  }

  Color _borderColor() {
    if (!widget.isEnabled) return AppColors.status100.withOpacity(0.1);
    if (widget.controller.text.isNotEmpty) return AppColors.green500;
    return AppColors.status100.withOpacity(0.2);
  }

  Color _textColor() =>
      widget.isEnabled
          ? AppColors.status100
          : AppColors.status100.withOpacity(0.4);

  @override
  Widget build(BuildContext context) {
    final borderColor = _borderColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTypography.caption1Regular.copyWith(color: _textColor()),
        ),
        const SizedBox(height: AppSpacing.spacing8),
        SizedBox(
          height: AppDimensions.inputFieldHeight,
          child: TextField(
            cursorColor: AppColors.green500,
            controller: widget.controller,
            enabled: widget.isEnabled,
            obscureText: _obscure,
            style: AppTypography.body2Regular.copyWith(color: _textColor()),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppTypography.body2Regular.copyWith(
                color: AppColors.status100.withOpacity(0.2),
              ),
              filled: true,
              fillColor: AppColors.status0,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spacing16
              ),
              enabledBorder: _getBorder(borderColor),
              focusedBorder: _getBorder(borderColor),
              disabledBorder: _getBorder(borderColor),
              errorBorder: _getBorder(AppColors.red500),
              focusedErrorBorder: _getBorder(AppColors.red500),
              suffixIcon:
                  widget.showToggleVisibility
                      ? IconButton(
                        onPressed: () {
                          setState(() {
                            _obscure = !_obscure;
                          });
                          widget.onToggleVisibility?.call();
                        },
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.status100.withOpacity(0.4),
                          size: AppDimensions.iconSize16
                        ),
                      )
                      : null,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.spacing8),
        if (widget.errorText != null)
          Text(
            widget.errorText!,
            style: AppTypography.caption2Medium.copyWith(
              color: AppColors.red500,
            ),
          ),
      ],
    );
  }
}
