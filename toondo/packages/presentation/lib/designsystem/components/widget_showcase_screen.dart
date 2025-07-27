import 'package:common/gen/assets.gen.dart';
import 'package:domain/entities/theme_mode_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:presentation/designsystem/components/bottom_sheets/app_goal_icon_bottom_sheet.dart';
import 'package:presentation/designsystem/components/bottom_sheets/app_goal_icon_categories.dart';
import 'package:presentation/designsystem/components/buttons/app_button.dart';
import 'package:presentation/designsystem/components/buttons/button_test_screen.dart';
import 'package:presentation/designsystem/components/dropdowns/app_goal_dropdown.dart';
import 'package:presentation/designsystem/components/navbars/app_nav_bar.dart';
import 'package:presentation/designsystem/components/setting/app_theme_radio_button.dart';
import 'package:presentation/designsystem/spacing/app_spacing.dart';

class WidgetShowcaseScreen extends StatefulWidget {
  const WidgetShowcaseScreen({super.key});

  @override
  State<WidgetShowcaseScreen> createState() => _WidgetShowcaseScreenState();
}

class _WidgetShowcaseScreenState extends State<WidgetShowcaseScreen> {
  final List<GoalDropdownItem> _goals = [
    GoalDropdownItem(
      id: 1,
      iconPath: Assets.icons.ic100point.path,
      title: '목표 이름',
    ),
    GoalDropdownItem(
      id: 2,
      iconPath: Assets.icons.icGithub.path,
      title: '목표 이름 2',
    ),
    GoalDropdownItem(
      id: 3,
      iconPath: Assets.icons.icBook.path,
      title: '목표 이름 3',
    ),
  ];

  String? _selectedGoalId;
  bool _isDropdownOpen = false;

  String? _selectedIconPath;
  ThemeModeType _selectedTheme = ThemeModeType.light;

  @override
  void initState() {
    super.initState();
    _selectedGoalId = _goals.first.id.toString();
  }

  void _showGoalIconBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AppGoalIconBottomSheet(
        iconCategories: goalIconCategories,
        onIconSelected: (iconPath) {
          setState(() {
            _selectedIconPath = iconPath;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(
        title: 'widget showcase',
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🎯 목표 드롭다운'),
                  const SizedBox(height: 8),

                  /// ✅ 교체된 드롭다운
                  AppGoalDropdown(
                    items: _goals,
                    selectedId: _selectedGoalId,
                    isExpanded: _isDropdownOpen,
                    onToggle: () {
                      setState(() {
                        _isDropdownOpen = !_isDropdownOpen;
                      });
                    },
                    onItemSelected: (selected) {
                      setState(() {
                        _selectedGoalId = selected.toString();
                        _isDropdownOpen = false;
                      });
                    },
                  ),

                  const SizedBox(height: 32),
                  const Text('📌 목표 바텀 시트'),
                  const SizedBox(height: 8),
                  AppButton(
                    label: '아이콘 선택 열기',
                    onPressed: _showGoalIconBottomSheet,
                    size: AppButtonSize.medium,
                  ),
                  if (_selectedIconPath != null) ...[
                    const SizedBox(height: 16),
                    const Text('선택된 아이콘:'),
                    const SizedBox(height: 8),
                    SvgPicture.asset(_selectedIconPath!, width: 40, height: 40),
                  ],
                  const SizedBox(height: 32),
                  const Text('🌙 테마 선택'),
                  const SizedBox(height: AppSpacing.spacing12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ThemeModeType.values.map((type) {
                      return AppThemeRadioButton(
                        type: type,
                        isSelected: _selectedTheme == type,
                        onTap: () {
                          setState(() {
                            _selectedTheme = type;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppButton(
              label: '다음으로',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ButtonTestScreen()),
                );
              },
              size: AppButtonSize.large,
            ),
          ),
        ],
      ),
    );
  }
}
