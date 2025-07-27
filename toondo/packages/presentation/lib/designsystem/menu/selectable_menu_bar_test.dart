import 'package:flutter/material.dart';
import 'package:presentation/designsystem/components/navbars/app_nav_bar.dart';
import 'package:presentation/designsystem/components/buttons/app_button.dart'; // ✅ 버튼 import
import 'package:presentation/designsystem/components/widget_showcase_screen.dart';
import 'package:presentation/designsystem/menu/app_selectable_menu_bar.dart';

class SelectableMenuBarTestScreen extends StatefulWidget {
  const SelectableMenuBarTestScreen({super.key});

  @override
  State<SelectableMenuBarTestScreen> createState() =>
      _SelectableMenuBarTestScreenState();
}

class _SelectableMenuBarTestScreenState
    extends State<SelectableMenuBarTestScreen> {
  int selectedTwoIndex = 0;
  int selectedThreeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(
        title: 'Selectable Menu Bar Test',
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('✅ 2개짜리 메뉴바'),
                    const SizedBox(height: 8),
                    AppSelectableMenuBar(
                      labels: const ['투두', '목표'],
                      selectedIndex: selectedTwoIndex,
                      onChanged: (index) {
                        setState(() {
                          selectedTwoIndex = index;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    const Text('✅ 3개짜리 메뉴바'),
                    const SizedBox(height: 8),
                    AppSelectableMenuBar(
                      labels: const ['전체', '목표', '중요'],
                      selectedIndex: selectedThreeIndex,
                      onChanged: (index) {
                        setState(() {
                          selectedThreeIndex = index;
                        });
                      },
                    ),
                  ],
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
                  MaterialPageRoute(builder: (_) => const WidgetShowcaseScreen()),
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
