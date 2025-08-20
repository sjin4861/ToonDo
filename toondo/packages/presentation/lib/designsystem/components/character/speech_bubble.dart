import 'package:flutter/material.dart';
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
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      maxLines: null,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth - 40); // padding 고려

    final width = textPainter.width + 44; // 좌우 패딩 포함
    final height = textPainter.height + 24; // 상하 패딩 + 꼬리 높이 포함

    return CustomPaint(
      painter: SpeechBubblePainter(width: width, height: height),
      child: Container(
        width: width,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
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
    this.borderColor = const Color(0x801C1D1B),
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

    canvas.drawPath(path, Paint()..color = color);
    canvas.drawPath(path, Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
