import 'dart:io';
import 'package:flutter/material.dart';

/// 커스텀 이미지 파일을 원형 아이콘으로 표시하는 공통 컴포넌트
/// 
/// 원형 컨테이너 안에 이미지를 완전히 채우기 위해:
/// - ClipOval + SizedBox.expand + Image.file 패턴 사용
/// - 부모 크기를 강제로 꽉 채워 배경이 비치지 않도록 함
/// - ScreenUtil을 사용하지 않고 정수 픽셀을 사용하여 반픽셀 문제 방지
class AppCircleFileIcon extends StatelessWidget {
  final String filePath;
  final double size; // 정수 픽셀 값만 사용 (ScreenUtil 미사용)
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final FilterQuality filterQuality;
  final Widget? errorWidget;

  const AppCircleFileIcon({
    super.key,
    required this.filePath,
    required this.size, // required로 변경 - 정수 픽셀 필수
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.filterQuality = FilterQuality.high,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final image = Image.file(
      File(filePath),
      fit: fit,
      alignment: alignment,
      filterQuality: filterQuality,
      errorBuilder: errorWidget != null
          ? (context, error, stackTrace) => errorWidget!
          : null,
    );

    return SizedBox(
      width: size, // 정수 픽셀
      height: size, // 정수 픽셀
      child: ClipOval(
        child: SizedBox.expand(
          child: image,
        ),
      ),
    );
  }
}
