import 'package:flutter/material.dart';
import 'package:presentation/designsystem/components/buttons/app_button.dart';
import 'package:presentation/designsystem/components/items/todo_list_test_screen.dart';
import 'package:presentation/designsystem/components/navbars/app_nav_bar.dart';
import 'package:presentation/designsystem/components/select_priority/app_eiwenhower_selector.dart';
import 'package:presentation/designsystem/components/toggles/app_goal_category_toggle.dart';
import 'package:presentation/designsystem/components/toggles/app_toggle_switch.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';
import 'package:presentation/models/eisenhower_model.dart';
import 'app_daily_chip.dart';

class ChipTestScreen extends StatefulWidget {
  const ChipTestScreen({super.key});

  @override
  State<ChipTestScreen> createState() => _ChipTestScreenState();
}

class _ChipTestScreenState extends State<ChipTestScreen> {
  bool _isDailyChipLeftSelected = true;
  bool _isToggleSwitchLeftSelected = true;
  int _goalCategorySelectedIndex = 0;
  EisenhowerType _selectedEisenhowerType = EisenhowerType.notImportantNotUrgent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(
        title: 'Chip Test',
        onBack: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('📌 DailyChip', style: AppTypography.body1Bold),
            const SizedBox(height: 16),
            AppDailyChip(
              isLeftSelected: _isDailyChipLeftSelected,
              onSelectedChanged: (value) {
                setState(() {
                  _isDailyChipLeftSelected = value;
                });
              },
            ),

            const SizedBox(height: 32),

            const Text('📌 Toggle Switch', style: AppTypography.body1Bold),
            const SizedBox(height: 16),
            AppToggleSwitch(
              value: _isToggleSwitchLeftSelected,
              onChanged: (value) {
                setState(() {
                  _isToggleSwitchLeftSelected = value;
                });
              },
            ),

            const SizedBox(height: 32),

            const Text('📌 Goal Category Toggle', style: AppTypography.body1Bold),
            const SizedBox(height: 16),
            AppGoalCategoryToggle(
              labels: const ['성공리스트', '실패리스트', '포기리스트'],
              selectedIndex: _goalCategorySelectedIndex,
              onChanged: (index) {
                setState(() {
                  _goalCategorySelectedIndex = index;
                });
              },
            ),

            const SizedBox(height: 32),

            const Text('📌 Eisenhower Selector', style: AppTypography.body1Bold),
            const SizedBox(height: 16),
            Center(
              child: AppEisenhowerSelector(
                selectedType: _selectedEisenhowerType,
                onChanged: (type) {
                  setState(() {
                    _selectedEisenhowerType = type;
                  });
                },
              ),
            ),

            const SizedBox(height: 100), // 스크롤 영역에 여유
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: AppButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TodoTestScreen()),
            );
          },
          label: '다음으로',
          size: AppButtonSize.large,
        ),
      ),
    );
  }
}
