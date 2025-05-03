import 'package:common/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class HomeBackground extends StatelessWidget {
  const HomeBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
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
          Positioned(
            bottom: 46,
            left: 0,
            right: 0,
            child: Assets.images.imgBackgroundGrass.svg(
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
