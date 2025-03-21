import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ResponsiveLayout extends StatelessWidget {
  ResponsiveLayout(
      {super.key, required this.mobileBody, required this.desktopBody});

  late Widget mobileBody;
  late Widget desktopBody;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, Constraints) {
      if (Constraints.maxWidth < 800) {
        return mobileBody;
      } else {
        return desktopBody;
      }
    });
  }
}

//LayOutBuilder 는 위젯의 크기에 따라 위젯트리를 빌드함!!