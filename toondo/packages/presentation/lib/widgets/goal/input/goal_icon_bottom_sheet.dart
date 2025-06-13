import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SVG 사용을 위해 추가

class GoalIconBottomSheet extends StatelessWidget {
  final Map<String, List<String>> iconCategories = {
    '수업/과제': [
      'assets/icons/ic_100point.svg',
      'assets/icons/ic_poo.svg',
      'assets/icons/ic_bomb.svg',
    ],
    '공부': [
      'assets/icons/ic_100point.svg',
      'assets/icons/ic_100point.svg',
      'assets/icons/ic_100point.svg',
    ],
    '운동/건강': [
      'assets/icons/ic_100point.svg',
      'assets/icons/ic_100point.svg',
      'assets/icons/ic_100point.svg',
    ],
    '취미/자기계발': [
      'assets/icons/ic_100point.svg',
      'assets/icons/ic_100point.svg',
      'assets/icons/ic_100point.svg',
    ],
    '기타': [
      'assets/icons/ic_100point.svg',
      'assets/icons/ic_100point.svg',
      'assets/icons/ic_100point.svg',
    ],
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
                children:
                    iconCategories.entries.map((entry) {
                      String category = entry.key;
                      List<String> icons = entry.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category,
                                style: const TextStyle(
                                  color: Color(0xFF1C1D1B),
                                  fontSize: 10,
                                  fontFamily: 'Pretendard Variable',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.15,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GridView.count(
                                crossAxisCount: 6,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                children: List.generate(6, (index) {
                                  if (index < icons.length) {
                                    final iconPath = icons[index];
                                    return GestureDetector(
                                      onTap:
                                          () =>
                                              Navigator.pop(context, iconPath),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color(0xFFDDDDDD),
                                            width: 1,
                                          ),
                                        ),
                                        child: SvgPicture.asset(
                                          iconPath,
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                    );
                                  } else {
                                    // 빈 아이템 (터치 불가)
                                    return Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFFDDDDDD),
                                          width: 1,
                                        ),
                                      ),
                                    );
                                  }
                                }),
                              ),
                            ],
                          ),
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
