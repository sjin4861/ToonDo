import 'package:flutter/material.dart';
import 'package:common/gen/assets.gen.dart';
import 'package:presentation/designsystem/components/items/app_todo_item.dart';
import 'package:presentation/designsystem/components/items/goal_item_test_screen.dart';
import 'package:presentation/designsystem/components/navbars/app_nav_bar.dart';
import 'package:presentation/designsystem/components/buttons/app_button.dart'; // ✅ 버튼 import
import 'package:presentation/designsystem/dimensions/app_dimensions.dart';

class TodoTestScreen extends StatefulWidget {
  const TodoTestScreen({super.key});

  @override
  State<TodoTestScreen> createState() => _TodoTestScreenState();
}

class _TodoTestScreenState extends State<TodoTestScreen> {
  final List<bool> isCheckedList = [true, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(
        title: 'todo item test',
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 5,
              separatorBuilder: (_, __) => SizedBox(height: AppDimensions.marginBottomTodoItem),
              itemBuilder: (context, index) {
                final isChecked = isCheckedList[index];

                final titleList = [
                  '완료된 과제',
                  '중요도가 4인 과제',
                  '중요도가 3인 과제',
                  '중요도가 2인 과제',
                  '중요도가 1인 과제',
                ];
                final colorList = [
                  const Color(0x80DDDDDD),
                  const Color(0xFFF8C0C1), // Priority 4
                  const Color(0xFFFBEB9C), // Priority 3
                  const Color(0xFFB0DFFB), // Priority 2
                  const Color(0xFFA9A29C), // Priority 1
                ];
                final iconList = [
                  Assets.icons.icBomb.path,
                  Assets.icons.icMonster.path,
                  Assets.icons.icMonster.path,
                  Assets.icons.ic100point.path,
                  Assets.icons.icGithub.path,
                ];
                final subtitleList = [
                  '24.08.31 ~ 24.11.03 D-2',
                  '24.08.31 ~ 24.11.03 D-3',
                  null,
                  null,
                  null,
                ];

                return Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 312,
                    child: AppTodoItem(
                      dismissKey: ValueKey(index),
                      title: titleList[index],
                      subTitle: subtitleList[index],
                      iconPath: iconList[index],
                      levelColor: colorList[index],
                      isChecked: isChecked,
                      onTap: () {
                        debugPrint('Tapped item: ${titleList[index]}');
                      },
                      onCheckedChanged: (checked) {
                        setState(() {
                          isCheckedList[index] = checked;
                        });
                      },
                      onSwipeLeft: () {
                        debugPrint('Swiped to delete: ${titleList[index]}');
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppButton(
              label: '다음으로',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GoalItemTestScreen()),
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
