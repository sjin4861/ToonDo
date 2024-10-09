import 'dart:ui';
import 'package:flutter/material.dart';

class ImageShadow extends StatelessWidget {
  final Widget child;
  final double opacity;
  final double sigma;
  final Color color;
  final Offset offset;
  final Matrix4? transform; // 추가된 속성

  const ImageShadow({
    super.key,
    required this.child,
    this.opacity = 0.5,
    this.sigma = 2,
    this.color = Colors.black,
    this.offset = const Offset(2, 2),
    this.transform, // 추가된 속성
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            return Transform(
              transform: transform ?? Matrix4.identity(),
              origin: Offset(width / 2, height / 2), // 변형의 기준점을 이미지의 중심으로 설정
              child: Transform.translate(
                offset: offset,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaY: sigma, sigmaX: sigma),
                  child: Opacity(
                    opacity: opacity,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(color, BlendMode.srcATop),
                      child: child,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        child,
      ],
    );
  }
}
