import 'package:flutter/material.dart';

class GoalIconBottomSheet extends StatelessWidget {
  final Map<String, List<String>> iconCategories = {
    '수업/과제': ['assets/icons/icon1.png', 'assets/icons/icon2.png', 'assets/icons/icon3.png'],
    '공부': ['assets/icons/icon4.png', 'assets/icons/icon5.png', 'assets/icons/icon6.png'],
    '운동/건강': ['assets/icons/icon7.png', 'assets/icons/icon8.png', 'assets/icons/icon9.png'],
    '취미/자기계발': ['assets/icons/icon10.png', 'assets/icons/icon11.png', 'assets/icons/icon12.png'],
    '기타': ['assets/icons/icon13.png', 'assets/icons/icon14.png', 'assets/icons/icon15.png'],
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 458,
      decoration: BoxDecoration(
        color: Color(0xFFFCFCFC),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // 상단 바
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              width: 126,
              height: 8,
              decoration: ShapeDecoration(
                color: Color(0xFFD9D9D9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
          // 아이콘 리스트
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: iconCategories.entries.map((entry) {
                  String category = entry.key;
                  List<String> icons = entry.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                          color: Color(0xFF1C1D1B),
                          fontSize: 10,
                          fontFamily: 'Pretendard Variable',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.15,
                        ),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: icons.map((iconPath) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context, iconPath);
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              padding: const EdgeInsets.all(4),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 1, color: Color(0xFFDDDDDD)),
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                              ),
                              child: Image.asset(
                                iconPath,
                                width: 24,
                                height: 24,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 24),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}