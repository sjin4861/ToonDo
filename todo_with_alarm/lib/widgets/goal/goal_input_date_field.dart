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

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF1C1D1B),
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
                      color: Color(0xFFDDDDDD)),
                  borderRadius:
                      BorderRadius.circular(1000),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 15,
                      color: Color(0xFFDDDDDD)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      date != null
                          ? viewModel.dateFormat.format(date)
                          : '${label}을 선택하세요',
                      style: TextStyle(
                        color: date != null
                            ? Color(0xFF1C1D1B)
                            : Color(0x3F1C1D1B),
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