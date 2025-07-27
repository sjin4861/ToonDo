import 'package:flutter/material.dart';
import 'package:common/gen/assets.gen.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';

enum EisenhowerType {
  notImportantNotUrgent,
  importantNotUrgent,
  urgentNotImportant,
  importantAndUrgent,
}

class EisenhowerOption {
  final EisenhowerType type;
  final String label;
  final String iconPath;
  final Color bgColor;
  final Color borderColor;
  final Color selectedColor;
  final Color unselectedColor;

  const EisenhowerOption({
    required this.type,
    required this.label,
    required this.iconPath,
    required this.bgColor,
    required this.borderColor,
    required this.selectedColor,
    required this.unselectedColor,
  });
}

final eisenhowerOptions = [
  EisenhowerOption(
    type: EisenhowerType.notImportantNotUrgent,
    label: '중요하거나\n급하지 않아',
    iconPath: Assets.icons.icFace0.path,
    bgColor: AppColors.eisenhowerSelectedBg1,
    borderColor: AppColors.eisenhowerSelectedBorder1,
    selectedColor: AppColors.eisenhowerActiveContent1,
    unselectedColor: AppColors.eisenhowerUnselectedContent,
  ),
  EisenhowerOption(
    type: EisenhowerType.importantNotUrgent,
    label: '중요하지만\n급하지는 않아',
    iconPath: Assets.icons.icFace1.path,
    bgColor: AppColors.eisenhowerSelectedBg2,
    borderColor: AppColors.eisenhowerSelectedBorder2,
    selectedColor: AppColors.eisenhowerActiveContent2,
    unselectedColor: AppColors.eisenhowerUnselectedContent,
  ),
  EisenhowerOption(
    type: EisenhowerType.urgentNotImportant,
    label: '급하지만\n중요하지 않아',
    iconPath: Assets.icons.icFace2.path,
    bgColor: AppColors.eisenhowerSelectedBg3,
    borderColor: AppColors.eisenhowerSelectedBorder3,
    selectedColor: AppColors.eisenhowerActiveContent3,
    unselectedColor: AppColors.eisenhowerUnselectedContent,
  ),
  EisenhowerOption(
    type: EisenhowerType.importantAndUrgent,
    label: '중요하고\n급한일이야!',
    iconPath: Assets.icons.icFace3.path,
    bgColor: AppColors.eisenhowerSelectedBg4,
    borderColor: AppColors.eisenhowerSelectedBorder4,
    selectedColor: AppColors.eisenhowerActiveContent4,
    unselectedColor: AppColors.eisenhowerUnselectedContent,
  ),
];
