import 'dart:math' as math;
import 'package:flutter/material.dart';

class NoodleLoader extends StatefulWidget {
  final double size;
  final Duration duration;

  const NoodleLoader({
    super.key,
    this.size = 170,
    this.duration = const Duration(milliseconds: 2800),
  });

  @override
  State<NoodleLoader> createState() => _NoodleLoaderState();
}

class _NoodleLoaderState extends State<NoodleLoader>
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
          final stir = Curves.easeInOut.transform(_range(.05, .60));
          final lift = Curves.easeOutBack.transform(_range(.62, .92));
          final drop = Curves.easeInOut.transform(_range(.92, 1.0));

          return CustomPaint(
            painter: _NoodlePainter(
              progress: _controller.value,
              stir: stir,
              lift: lift * (1 - drop),
            ),
          );
        },
      ),
    );
  }
}

class _NoodlePainter extends CustomPainter {
  final double progress;
  final double stir;
  final double lift;

  _NoodlePainter({
    required this.progress,
    required this.stir,
    required this.lift,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 170;
    canvas.scale(s);

    _drawShadow(canvas);
    _drawSteam(canvas);
    _drawBowl(canvas);
    _drawSoup(canvas);
    _drawNoodles(canvas);
    _drawFork(canvas);
    _drawHighlights(canvas);
  }

  void _drawShadow(Canvas canvas) {
    canvas.drawOval(
      const Rect.fromLTWH(37, 143, 96, 12),
      Paint()..color = Colors.black.withOpacity(.28),
    );
  }

  void _drawSteam(Canvas canvas) {
    final steamOpacity = (1 - lift).clamp(0.0, 1.0);

    final paint = Paint()
      ..color = Colors.white.withOpacity(.48 * steamOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 4; i++) {
      final x = 55.0 + i * 20;
      final wave = math.sin(progress * math.pi * 2 + i) * 5;

      final path = Path()
        ..moveTo(x, 72)
        ..cubicTo(
          x - 9 + wave,
          58,
          x + 10 - wave,
          50,
          x,
          38,
        );

      canvas.drawPath(path, paint);
    }
  }

  void _drawBowl(Canvas canvas) {
    final bowlRect = const Rect.fromLTWH(27, 88, 116, 58);

    canvas.drawRRect(
      RRect.fromRectAndRadius(bowlRect, const Radius.circular(30)),
      Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0xFFFFF7ED),
            Color(0xFFF97316),
            Color(0xFFC2410C),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(bowlRect),
    );

    canvas.drawOval(
      const Rect.fromLTWH(25, 78, 120, 32),
      Paint()..color = const Color(0xFFFFFBEB),
    );

    canvas.drawOval(
      const Rect.fromLTWH(35, 84, 100, 19),
      Paint()..color = const Color(0xFFFBBF24).withOpacity(.75),
    );
  }

  void _drawSoup(Canvas canvas) {
    final soupPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFDE68A).withOpacity(.95),
          const Color(0xFFF59E0B).withOpacity(.75),
        ],
      ).createShader(const Rect.fromLTWH(38, 82, 94, 22));

    canvas.drawOval(const Rect.fromLTWH(39, 85, 92, 16), soupPaint);

    final bubblePaint = Paint()..color = Colors.white.withOpacity(.35);
    canvas.drawCircle(const Offset(62, 91), 3, bubblePaint);
    canvas.drawCircle(const Offset(102, 92), 2.4, bubblePaint);
    canvas.drawCircle(const Offset(82, 88), 2, bubblePaint);
  }

  void _drawNoodles(Canvas canvas) {
    final center = Offset(84, 82 - lift * 36);
    final rotation = progress * math.pi * 2.6;
    final noodlePaint = Paint()
      ..color = const Color(0xFFFFE082)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 7; i++) {
      final path = Path();
      final radius = 18.0 + i * 1.7;
      final start = rotation + i * .55;

      for (double t = 0; t <= math.pi * 2.1; t += .10) {
        final x = center.dx +
            math.cos(t + start) * radius * .58 +
            math.sin(progress * math.pi * 4 + i) * 1.5;
        final y = center.dy + math.sin(t + start) * 8 + i * 2.2;

        if (t == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(path, noodlePaint);
    }

    final hangingPaint = Paint()
      ..color = const Color(0xFFFDE68A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.3
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 6; i++) {
      final x = 61.0 + i * 9;
      final sway = math.sin(progress * math.pi * 5 + i) * 8;

      final path = Path()
        ..moveTo(x, 91 - lift * 36)
        ..cubicTo(
          x + sway,
          102 - lift * 24,
          x - sway,
          112 - lift * 10,
          x + 4,
          126,
        );

      canvas.drawPath(path, hangingPaint);
    }

    final toppingPaint = Paint()..color = const Color(0xFF22C55E);
    canvas.drawCircle(Offset(60, 86 - lift * 18), 3, toppingPaint);
    canvas.drawCircle(Offset(106, 88 - lift * 20), 3, toppingPaint);
    canvas.drawCircle(Offset(92, 78 - lift * 26), 2.5, toppingPaint);
  }

  void _drawFork(Canvas canvas) {
    final forkPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final angle = math.sin(progress * math.pi * 2) * .28 * (1 - lift * .3);
    final liftY = lift * 36;

    canvas.save();
    canvas.translate(102, 48 - liftY);
    canvas.rotate(angle);

    canvas.drawLine(const Offset(0, 2), const Offset(28, 58), forkPaint);

    for (int i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(-12 + i * 7, -12),
        Offset(-12 + i * 7, 12),
        forkPaint,
      );
    }

    canvas.restore();
  }

  void _drawHighlights(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(44, 101, 72, 10),
        const Radius.circular(20),
      ),
      Paint()..color = Colors.white.withOpacity(.18),
    );
  }

  @override
  bool shouldRepaint(covariant _NoodlePainter oldDelegate) => true;
}