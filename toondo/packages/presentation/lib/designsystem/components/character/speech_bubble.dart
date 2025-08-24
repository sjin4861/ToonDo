import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presentation/designsystem/colors/app_colors.dart';
import 'package:presentation/designsystem/typography/app_typography.dart';

class SpeechBubble extends StatelessWidget {
  final String text;
  final double maxWidth;

  const SpeechBubble({
    super.key,
    required this.text,
    this.maxWidth = 240,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTypography.speechBubbleRegular;

    // 반응형 값들
    final double maxW = maxWidth.w;
    final double padH = 20.w;
    final double padTop = 6.h;
    final double padBottom = 10.h;
    final double extraWidth = 4.w;

    // TextPainter로 실제 텍스트 폭/높이 측정
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      maxLines: null,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxW - (padH * 2) - extraWidth);

    final double bubbleW =
    (textPainter.width + (padH * 2) + extraWidth).clamp(0, maxW);
    final double bubbleH = textPainter.height + padTop + padBottom + 6.h; // 꼬리 높이 포함

    return CustomPaint(
      painter: SpeechBubblePainter(
        width: bubbleW,
        height: bubbleH,
        color: const Color(0xFFFFFEFB),
        borderColor: AppColors.status100_50,
        radius: 14.r,
        tailHeight: 6.h,
        tailWidth: 10.w,
        borderWidth: 0.1.w,
      ),
      child: Container(
        width: bubbleW,
        padding: EdgeInsets.fromLTRB(padH, padTop, padH, padBottom),
        child: Text(
          text,
          style: textStyle,
          softWrap: true,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class SpeechBubblePainter extends CustomPainter {
  final double width;
  final double height;
  final Color color;
  final double radius;
  final double tailHeight;
  final double tailWidth;
  final Color borderColor;
  final double borderWidth;

  SpeechBubblePainter({
    required this.width,
    required this.height,
    this.color = const Color(0xFFFFFEFB),
    this.radius = 16,
    this.tailHeight = 6,
    this.tailWidth = 10,
    this.borderColor = AppColors.status100_50,
    this.borderWidth = 0.1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bubbleHeight = height - tailHeight;
    final tailCenter = width / 2;

    final path = Path()
      ..moveTo(radius, 0)
      ..arcToPoint(Offset(0, radius), radius: Radius.circular(radius), clockwise: false)
      ..lineTo(0, bubbleHeight - radius)
      ..arcToPoint(Offset(radius, bubbleHeight), radius: Radius.circular(radius), clockwise: false)
      ..lineTo(tailCenter - tailWidth / 2, bubbleHeight)
      ..lineTo(tailCenter, bubbleHeight + tailHeight)
      ..lineTo(tailCenter + tailWidth / 2, bubbleHeight)
      ..lineTo(width - radius, bubbleHeight)
      ..arcToPoint(Offset(width, bubbleHeight - radius), radius: Radius.circular(radius), clockwise: false)
      ..lineTo(width, radius)
      ..arcToPoint(Offset(width - radius, 0), radius: Radius.circular(radius), clockwise: false)
      ..close();

    final fillPaint = Paint()..color = color;
    final strokePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant SpeechBubblePainter old) {
    return width != old.width ||
        height != old.height ||
        color != old.color ||
        radius != old.radius ||
        tailHeight != old.tailHeight ||
        tailWidth != old.tailWidth ||
        borderColor != old.borderColor ||
        borderWidth != old.borderWidth;
  }
}
