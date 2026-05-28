import 'package:flutter/material.dart';
import 'dart:math' as math;

class ToastLoader extends StatefulWidget {
  final double size;
  final Duration duration;

  const ToastLoader({
    super.key,
    this.size = 160,
    this.duration = const Duration(milliseconds: 2800),
  });

  @override
  State<ToastLoader> createState() => _ToastLoaderState();
}

class _ToastLoaderState extends State<ToastLoader>
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
        builder: (context, child) {
          final down = Curves.easeInOutCubic.transform(_range(.05, .34));
          final heat = Curves.easeInOut.transform(_range(.34, .66));
          final pop = Curves.elasticOut.transform(_range(.63, .90));
          final steam = Curves.easeOut.transform(_range(.68, 1.0));

          final breadY = -55 + (down * 62) - (pop * 58);
          final shake = heat > 0
              ? math.sin(_controller.value * math.pi * 34) * 2.2 * heat
              : 0.0;

          return Transform.translate(
            offset: Offset(shake, 0),
            child: CustomPaint(
              painter: _ToastPainter(
                progress: _controller.value,
                breadY: breadY,
                heat: heat,
                steam: steam,
                toasted: pop > .18,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ToastPainter extends CustomPainter {
  final double progress;
  final double breadY;
  final double heat;
  final double steam;
  final bool toasted;

  _ToastPainter({
    required this.progress,
    required this.breadY,
    required this.heat,
    required this.steam,
    required this.toasted,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 160;
    canvas.scale(s);

    _drawSteam(canvas);
    _drawHeatGlow(canvas);
    _drawBread(canvas);
    _drawToaster(canvas);
    _drawLever(canvas);
    _drawShadow(canvas);
  }

  void _drawShadow(Canvas canvas) {
    canvas.drawOval(
      const Rect.fromLTWH(38, 138, 84, 12),
      Paint()..color = Colors.black.withOpacity(.25),
    );
  }

  void _drawSteam(Canvas canvas) {
    if (steam <= 0) return;

    final paint = Paint()
      ..color = Colors.white.withOpacity(.65 * (1 - (steam * .25)))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 3; i++) {
      final x = 62.0 + (i * 18);
      final wave = math.sin(progress * math.pi * 2 + i) * 5;

      final path = Path()
        ..moveTo(x, 42 - steam * 16)
        ..cubicTo(
          x - 12 + wave,
          33 - steam * 18,
          x + 14 - wave,
          24 - steam * 21,
          x,
          12 - steam * 18,
        );

      canvas.drawPath(path, paint);
    }
  }

  void _drawHeatGlow(Canvas canvas) {
    if (heat <= 0) return;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(28, 70, 104, 68),
        const Radius.circular(32),
      ),
      Paint()
        ..color = Colors.orangeAccent.withOpacity(.30 * heat)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24),
    );

    canvas.drawCircle(
      const Offset(80, 94),
      36 * heat,
      Paint()
        ..color = Colors.amber.withOpacity(.12 * heat)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
    );
  }

  void _drawBread(Canvas canvas) {
    final crustPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFB45309), Color(0xFF78350F)],
      ).createShader(const Rect.fromLTWH(52, 32, 56, 62));

    final breadPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: toasted
            ? const [Color(0xFFEAB308), Color(0xFFD97706)]
            : const [Color(0xFFFFE0B2), Color(0xFFFFB86B)],
      ).createShader(Rect.fromLTWH(56, 38 + breadY, 48, 50));

    final crust = RRect.fromRectAndCorners(
      Rect.fromLTWH(52, 32 + breadY, 56, 62),
      topLeft: const Radius.circular(24),
      topRight: const Radius.circular(24),
      bottomLeft: const Radius.circular(10),
      bottomRight: const Radius.circular(10),
    );

    final inner = RRect.fromRectAndCorners(
      Rect.fromLTWH(58, 40 + breadY, 44, 48),
      topLeft: const Radius.circular(19),
      topRight: const Radius.circular(19),
      bottomLeft: const Radius.circular(7),
      bottomRight: const Radius.circular(7),
    );

    canvas.drawRRect(crust, crustPaint);
    canvas.drawRRect(inner, breadPaint);

    final spotPaint = Paint()..color = Colors.brown.withOpacity(.25);
    canvas.drawCircle(Offset(70, 59 + breadY), 4.5, spotPaint);
    canvas.drawCircle(Offset(89, 70 + breadY), 3.3, spotPaint);
    canvas.drawCircle(Offset(81, 51 + breadY), 2.8, spotPaint);
    canvas.drawCircle(Offset(69, 77 + breadY), 2.5, spotPaint);

    canvas.drawCircle(
      Offset(70, 50 + breadY),
      5,
      Paint()..color = Colors.white.withOpacity(.18),
    );
  }

  void _drawToaster(Canvas canvas) {
    final bodyRect = const Rect.fromLTWH(30, 78, 100, 60);

    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFF7A18), Color(0xFFE85D04), Color(0xFFB45309)],
      ).createShader(bodyRect);

    final darkPaint = Paint()..color = const Color(0xFF431407);

    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, const Radius.circular(24)),
      bodyPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(48, 68, 64, 10),
        const Radius.circular(20),
      ),
      darkPaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(42, 87, 74, 14),
        const Radius.circular(12),
      ),
      Paint()..color = Colors.white.withOpacity(.20),
    );

    canvas.drawCircle(
      const Offset(54, 120),
      9,
      Paint()..color = Colors.white.withOpacity(.95),
    );

    canvas.drawCircle(
      const Offset(54, 120),
      4,
      Paint()..color = const Color(0xFF7C2D12),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(84, 116, 28, 7),
        const Radius.circular(10),
      ),
      Paint()..color = Colors.white.withOpacity(.82),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(112, 84, 10, 47),
        const Radius.circular(14),
      ),
      Paint()..color = Colors.black.withOpacity(.12),
    );
  }

  void _drawLever(Canvas canvas) {
    final leverDown = heat > 0 ? heat : 0.0;
    final y = 88 + (leverDown * 26);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(130, 88, 5, 42),
        const Radius.circular(10),
      ),
      Paint()..color = const Color(0xFF7C2D12),
    );

    canvas.drawCircle(
      Offset(132.5, y),
      8,
      Paint()..color = const Color(0xFFFFEDD5),
    );

    canvas.drawCircle(
      Offset(132.5, y),
      4,
      Paint()..color = const Color(0xFFE85D04),
    );
  }

  @override
  bool shouldRepaint(covariant _ToastPainter oldDelegate) => true;
}
