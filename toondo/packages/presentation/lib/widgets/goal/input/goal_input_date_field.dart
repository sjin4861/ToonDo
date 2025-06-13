import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class GoalInputDateField extends StatelessWidget {
  final viewModel;
  final String label;

  GoalInputDateField({required this.viewModel, required this.label});

  @override
  Widget build(BuildContext context) {
    // label에 따라 isStartDate 설정
    bool isStartDate = label == '시작일';
    // label에 따라 표시할 날짜 결정
    DateTime? date = isStartDate ? viewModel.startDate : viewModel.endDate;
    final Color borderColor = date != null ? const Color(0xFF78B545) : const Color(0xFFDDDDDD);
    final Color textColor = date != null ? const Color(0xFF1C1D1B) : const Color(0x3F1C1D1B);
    final Color iconColor = date != null ? const Color(0xFF1C1D1B) : const Color(0xFFDDDDDD);


    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.15,
              fontFamily: 'Pretendard Variable',
            ),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () => viewModel.selectDate(context, isStartDate: isStartDate),
            child: Container(
              height: 32,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 1,
                      color: borderColor),
                  borderRadius:
                      BorderRadius.circular(1000),
                ),
              ),
              child: Row(
                children: [
                  Assets.icons.icCalendar.svg(
                    width: 15,
                    height: 15,
                    colorFilter: ColorFilter.mode(
                      iconColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      date != null
                          ? viewModel.dateFormat.format(date)
                          : '${label}을 선택하세요',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.15,
                        fontFamily: 'Pretendard Variable',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
    );
  } // build
} // DateField