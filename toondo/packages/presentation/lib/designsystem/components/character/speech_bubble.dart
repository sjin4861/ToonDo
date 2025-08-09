import 'package:flutter/material.dart';

class SpeechBubble extends StatefulWidget {
  final String message;
  final Duration displayDuration;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color textColor;
  final double maxWidth;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final bool showTail;
  final Alignment tailAlignment;

  const SpeechBubble({
    super.key,
    required this.message,
    this.displayDuration = const Duration(seconds: 3),
    this.onTap,
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.textColor = const Color(0xFF333333),
    this.maxWidth = 200,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.showTail = true,
    this.tailAlignment = Alignment.bottomCenter,
  });

  @override
  State<SpeechBubble> createState() => _SpeechBubbleState();
}

class _SpeechBubbleState extends State<SpeechBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();

    // 자동으로 사라지는 타이머
    Future.delayed(widget.displayDuration, () {
      if (mounted) {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: GestureDetector(
              onTap: widget.onTap,
              child: CustomPaint(
                painter: _SpeechBubblePainter(
                  backgroundColor: widget.backgroundColor,
                  showTail: widget.showTail,
                  tailAlignment: widget.tailAlignment,
                  borderRadius: widget.borderRadius,
                ),
                child: Container(
                  constraints: BoxConstraints(maxWidth: widget.maxWidth),
                  padding: widget.padding,
                  child: Text(
                    widget.message,
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SpeechBubblePainter extends CustomPainter {
  final Color backgroundColor;
  final bool showTail;
  final Alignment tailAlignment;
  final BorderRadius borderRadius;

  _SpeechBubblePainter({
    required this.backgroundColor,
    required this.showTail,
    required this.tailAlignment,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    // 그림자 그리기
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final shadowPath = _createBubblePath(size, offset: const Offset(2, 2));
    canvas.drawPath(shadowPath, shadowPaint);

    // 말풍선 본체 그리기
    final bubblePath = _createBubblePath(size);
    canvas.drawPath(bubblePath, paint);

    // 테두리 그리기
    final borderPaint = Paint()
      ..color = backgroundColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawPath(bubblePath, borderPaint);
  }

  Path _createBubblePath(Size size, {Offset offset = Offset.zero}) {
    final path = Path();
    final rect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      size.width,
      size.height - (showTail ? 12 : 0),
    );

    // 둥근 사각형 생성
    path.addRRect(RRect.fromRectAndCorners(
      rect,
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    ));

    // 말풍선 꼬리 추가
    if (showTail) {
      final tailWidth = 16.0;
      final tailHeight = 12.0;
      final tailX = (size.width / 2) - (tailWidth / 2) + offset.dx;
      final tailY = rect.bottom + offset.dy;

      path.moveTo(tailX, tailY);
      path.lineTo(tailX + tailWidth / 2, tailY + tailHeight);
      path.lineTo(tailX + tailWidth, tailY);
      path.close();
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 말풍선을 위한 애니메이션 스타일 열거형
enum SpeechBubbleAnimationType {
  bounce,
  fadeIn,
  slideUp,
  scale,
}

/// 미리 정의된 말풍선 스타일
class SpeechBubbleStyles {
  static const friendly = SpeechBubble(
    message: '',
    backgroundColor: Color(0xFF4CAF50),
    textColor: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(24)),
  );

  static const excited = SpeechBubble(
    message: '',
    backgroundColor: Color(0xFFFF9800),
    textColor: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(16)),
  );

  static const calm = SpeechBubble(
    message: '',
    backgroundColor: Color(0xFF2196F3),
    textColor: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(20)),
  );

  static const encouraging = SpeechBubble(
    message: '',
    backgroundColor: Color(0xFF9C27B0),
    textColor: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(18)),
  );
}
