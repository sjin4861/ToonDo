import 'dart:ui';
import 'package:flutter/material.dart';

class ImageShadow extends StatelessWidget {
  final Widget child;
  final double opacity;
  final double sigma;
  final Color color;
  final Offset offset;

  const ImageShadow({
    super.key,
    required this.child,
    this.opacity = 0.5,
    this.sigma = 2,
    this.color = Colors.black,
    this.offset = const Offset(2, 2),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // 그림자 효과를 가진 위젯
        Transform.translate(
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
        // 원본 이미지
        child,
      ],
    );
  }
}
