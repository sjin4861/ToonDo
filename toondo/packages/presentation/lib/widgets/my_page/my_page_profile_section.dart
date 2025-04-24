import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyPageProfileSection extends StatelessWidget {
  const MyPageProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            const SizedBox(
              width: 85,
              height: 85,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: Color(0xFFE5E1F5),
                  shape: OvalBorder(),
                ),
              ),
            ),
            const SizedBox(
              width: 59,
              height: 59,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFC0AEFF), Color(0xFFAB94FD)],
                  ),
                  shape: OvalBorder(),
                ),
              ),
            ),
            Center(
              child: Assets.images.imgProfileDefault.svg(
                width: 86,
                height: 86,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        const SizedBox(width: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '드리머즈',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text.rich(
              TextSpan(
                children: const [
                  TextSpan(
                    text: 'ToonDo',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: '와 함께한 지 '),
                  TextSpan(
                    text: '21',
                    style: TextStyle(color: Color(0xFF78B545)),
                  ),
                  TextSpan(text: '일째'),
                ],
              ),
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }
}
