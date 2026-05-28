import 'dart:math' as math;
import 'package:flutter/material.dart';

class CoffeeLoader extends StatefulWidget {
  final double size;
  final Duration duration;

  const CoffeeLoader({
    super.key,
    this.size = 180,
    this.duration = const Duration(milliseconds: 3200),
  });

  @override
  State<CoffeeLoader> createState() => _CoffeeLoaderState();
}

class _CoffeeLoaderState extends State<CoffeeLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _range(double start, double end) {
    final t = _controller.value;
    if (t < start) return 0;
    if (t > end) return 1;
    return (t - start) / (end - start);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          final pour = Curves.easeInOut.transform(_range(.08, .66));
          final steam = Curves.easeOut.transform(_range(.68, 1.0));

          return CustomPaint(
            painter: _CoffeePainter(
              progress: _controller.value,
              pour: pour,
              steam: steam,
            ),
          );
        },
      ),
    );
  }
}

class _CoffeePainter extends CustomPainter {
  final double progress;
  final double pour;
  final double steam;

  _CoffeePainter({
    required this.progress,
    required this.pour,
    required this.steam,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 180;
    canvas.scale(s);

    _drawShadow(canvas);
    _drawMachine(canvas);
    _drawCoffeeStream(canvas);
    _drawCup(canvas);
    _drawSteam(canvas);
  }

  void _drawShadow(Canvas canvas) {
    canvas.drawOval(
      const Rect.fromLTWH(48, 158, 88, 12),
      Paint()..color = Colors.black.withOpacity(.28),
    );
  }

  void _drawMachine(Canvas canvas) {
    final bodyRect = const Rect.fromLTWH(38, 20, 104, 90);

    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFF8FAFC), Color(0xFFCBD5E1), Color(0xFF64748B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bodyRect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, const Radius.circular(18)),
      bodyPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(50, 34, 80, 20),
        const Radius.circular(10),
      ),
      Paint()..color = const Color(0xFF111827),
    );

    canvas.drawCircle(
      const Offset(60, 44),
      5,
      Paint()..color = const Color(0xFF22C55E),
    );

    canvas.drawCircle(
      const Offset(76, 44),
      5,
      Paint()..color = const Color(0xFFF97316),
    );

    canvas.drawCircle(
      const Offset(116, 44),
      7,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFF94A3B8)],
        ).createShader(const Rect.fromLTWH(108, 36, 16, 16)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(70, 62, 40, 14),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFF1F2937),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(83, 75, 14, 18),
        const Radius.circular(5),
      ),
      Paint()..color = const Color(0xFF374151),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(55, 102, 70, 8),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFF475569),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(44, 26, 36, 6),
        const Radius.circular(10),
      ),
      Paint()..color = Colors.white.withOpacity(.45),
    );
  }

  void _drawCoffeeStream(Canvas canvas) {
    if (pour <= 0 || pour >= .98) return;

    final wave = math.sin(progress * math.pi * 12) * 1.5;

    final paint = Paint()
      ..color = const Color(0xFF7C2D12)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(90, 92)
      ..cubicTo(90 + wave, 108, 90 - wave, 118, 90, 130);

    canvas.drawPath(path, paint);

    canvas.drawCircle(
      Offset(90 + wave, 130 + math.sin(progress * math.pi * 8) * 3),
      3.5,
      Paint()..color = const Color(0xFF92400E),
    );
  }

  void _drawCup(Canvas canvas) {
    final cupRect = const Rect.fromLTWH(58, 118, 64, 40);

    canvas.drawRRect(
      RRect.fromRectAndRadius(cupRect, const Radius.circular(14)),
      Paint()..color = const Color(0xFFF8FAFC),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(63, 124, 54, 29),
        const Radius.circular(10),
      ),
      Paint()..color = const Color(0xFFE2E8F0),
    );

    final coffeeHeight = 26 * pour;
    final coffeeTop = 151 - coffeeHeight;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(66, coffeeTop, 48, coffeeHeight),
        const Radius.circular(8),
      ),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF92400E), Color(0xFF451A03)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(66, coffeeTop, 48, coffeeHeight)),
    );

    if (pour > .78) {
      canvas.drawOval(
        Rect.fromLTWH(67, coffeeTop - 4, 46, 8),
        Paint()..color = const Color(0xFFFBBF24).withOpacity(.65),
      );
    }

    canvas.drawOval(
      const Rect.fromLTWH(52, 126, 22, 24),
      Paint()
        ..color = Colors.transparent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );

    canvas.drawArc(
      const Rect.fromLTWH(112, 128, 22, 22),
      -math.pi / 2,
      math.pi,
      false,
      Paint()
        ..color = const Color(0xFFF8FAFC)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(68, 122, 34, 5),
        const Radius.circular(10),
      ),
      Paint()..color = Colors.white.withOpacity(.5),
    );
  }

  void _drawSteam(Canvas canvas) {
    if (steam <= 0) return;

    final paint = Paint()
      ..color = Colors.white.withOpacity(.55 * steam)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 3; i++) {
      final x = 72.0 + i * 15;
      final wave = math.sin(progress * math.pi * 2 + i) * 5;

      final path = Path()
        ..moveTo(x, 120 - steam * 8)
        ..cubicTo(
          x - 9 + wave,
          108 - steam * 10,
          x + 9 - wave,
          100 - steam * 14,
          x,
          90 - steam * 18,
        );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CoffeePainter oldDelegate) => true;
}
