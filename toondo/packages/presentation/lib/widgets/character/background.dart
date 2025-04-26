// lib/widgets/home_background.dart

import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class HomeBackground extends StatelessWidget {
  const HomeBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          // (1) 배경 그라데이션
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xFFFDF8EB), Color(0xFFE2F1F6)],
                ),
              ),
            ),
          ),
          // (2) 왼쪽 수풀
          Positioned(
            left: 0,
            bottom: 80,
            child: Assets.images.imgGroup2.svg(fit: BoxFit.cover),
          ),
          // (3) 오른쪽 수풀
          Positioned(
            right: 0,
            bottom: 80,
            child: Assets.images.imgGroup3.svg(fit: BoxFit.cover),
          ),
          // (4) 갈색 바닥(줄 3개)
          Positioned(
            left: 0,
            right: 0,
            bottom: 80, // 기존 0에서 60으로 증가
            // 높이는 예시로 110
            child: Container(
              height: 80,
              color: const Color(0xFFECDFBB),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (index) {
                  return Container(
                    width: double.infinity,
                    height: 2,
                    color: const Color.fromARGB(255, 248, 238, 226),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
