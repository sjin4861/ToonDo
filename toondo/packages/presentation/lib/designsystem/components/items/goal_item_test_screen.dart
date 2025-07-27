import 'package:flutter/material.dart';
import 'package:common/gen/assets.gen.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/components/navbars/app_nav_bar.dart';
import 'package:presentation/designsystem/components/buttons/app_button.dart'; // ✅ 버튼 import
import 'package:presentation/designsystem/menu/selectable_menu_bar_test.dart';
import 'app_goal_item.dart';

class GoalItemTestScreen extends StatefulWidget {
  const GoalItemTestScreen({super.key});

  @override
  State<GoalItemTestScreen> createState() => _GoalItemTestScreenState();
}

class _GoalItemTestScreenState extends State<GoalItemTestScreen> {
  final List<bool> _checkedList = List.generate(5, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(
        title: 'goal item test',
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: 328,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: _checkedList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final isSpecialBackground = index == 1 || index == 3;

                    return AppGoalItem(
                      dismissKey: ValueKey("goal_$index"),
                      title: "목표 ${index + 1}",
                      subTitle: index % 2 == 0 ? "24.08.31 ~ 24.11.03" : null,
                      iconPath: Assets.icons.ic100point.path,
                      isChecked: _checkedList[index],
                      backgroundColor: isSpecialBackground
                          ? AppColors.green100
                          : Colors.transparent,
                      onCheckedChanged: (value) {
                        setState(() {
                          _checkedList[index] = value;
                        });
                      },
                      onTap: () {
                        debugPrint("Tapped goal item $index");
                      },
                      onSwipeLeft: () {
                        debugPrint("Swiped left on goal item $index");
                      },
                    );
                  },
                ),
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
                  MaterialPageRoute(builder: (_) => const SelectableMenuBarTestScreen()),
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
