import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../lib/viewmodels/goal/goal_input_viewmodel.dart';
import '../goal/goal_icon_bottom_sheet.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SVG 사용을 위해 추가

class GoalNameInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  GoalNameInputField({
    Key? key,
    required this.controller,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GoalInputViewModel>(context, listen: false);
    //viewModel.selectIcon("assets/icons/100point.svg");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('목표 이름', style: _textStyle(Color(0xFF1C1D1B), 10, FontWeight.w400)),
        SizedBox(height: 8),
        Row(
          children: [
            // 아이콘 선택 버튼
            GestureDetector(
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
                    color: viewModel.selectedIcon != null
                        ? const Color(0xFF78B545)
                        : Colors.grey,
                    width: 1,
                  ),
                  color: Colors.grey[200],
                ),
                child: viewModel.selectedIcon != null
                    ? ClipOval(
                        child: SvgPicture.asset(
                          viewModel.selectedIcon!,
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                        ),
                      )
                    : const Icon(
                        Icons.add,
                        color: Colors.grey,
                      ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: 
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: '목표 이름을 입력해주세요.',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1000),
                      borderSide: BorderSide(
                        color: controller.text.isNotEmpty ? Color(0xFF78B545) : Color(0xFFDDDDDD),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(1000),
                      borderSide: BorderSide(
                        color: controller.text.isNotEmpty ? Color(0xFF78B545) : Color(0xFFDDDDDD),
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
            )
          ]
        ),
        if (errorText != null) ...[
          SizedBox(height: 4),
          Text(errorText!, style: _textStyle(Color(0xFFEE0F12), 10, FontWeight.w400)),
        ],
      ],
    );
  }

  TextStyle _textStyle(Color color, double fontSize, FontWeight fontWeight) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: 'Pretendard Variable',
      fontWeight: fontWeight,
      letterSpacing: 0.15,
    );
  }
}
