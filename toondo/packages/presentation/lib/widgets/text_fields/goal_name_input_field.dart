import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:presentation/viewmodels/goal/goal_input_viewmodel.dart';
import 'package:presentation/widgets/goal/input/goal_icon_bottom_sheet.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SVG 사용을 위해 추가

class GoalNameInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;

  const GoalNameInputField({
    Key? key,
    required this.controller,
    this.errorText,
  }) : super(key: key);

  @override
  State<GoalNameInputField> createState() => _GoalNameInputFieldState();
}

class _GoalNameInputFieldState extends State<GoalNameInputField> {
  @override
  Widget build(BuildContext context) {
    // Consumer로 감싸서 전체 위젯이 아닌 필요한 부분만 리빌드되도록 함
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('목표 이름', style: _textStyle(Color(0xFF1C1D1B), 10, FontWeight.w400)),
        SizedBox(height: 8),
        Row(
          children: [
            // 아이콘 선택 버튼
            Consumer<GoalInputViewModel>(
              builder: (context, viewModel, child) => GestureDetector(
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
                          : const Color(0xFFDDDDDD),
                      width: 1.5,
                    ),
                    // 회색 배경에서 흰색 배경으로 변경
                    color: Colors.white,
                    // 그림자 효과 추가
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
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
                          color: Color(0xFF78B545), // 초록색 계열로 아이콘 색상 변경
                          size: 22,
                        ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: widget.controller,
                // onChanged를 사용하지 않음으로써 매 입력마다 notifyListeners가 호출되지 않도록 함
                decoration: InputDecoration(
                  hintText: '목표 이름을 입력해주세요.',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(1000),
                    borderSide: BorderSide(
                      color: widget.controller.text.isNotEmpty ? Color(0xFF78B545) : Color(0xFFDDDDDD),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(1000),
                    borderSide: BorderSide(
                      color: widget.controller.text.isNotEmpty ? Color(0xFF78B545) : Color(0xFFDDDDDD),
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            )
          ]
        ),
        if (widget.errorText != null) ...[
          SizedBox(height: 4),
          Text(widget.errorText!, style: _textStyle(Color(0xFFEE0F12), 10, FontWeight.w400)),
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
