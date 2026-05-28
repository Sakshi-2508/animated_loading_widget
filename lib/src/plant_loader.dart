import 'dart:math' as math;
import 'package:flutter/material.dart';

class PlantLoader extends StatefulWidget {
  final double size;
  final Duration duration;

  const PlantLoader({
    super.key,
    this.size = 180,
    this.duration = const Duration(milliseconds: 3200),
  });

  @override
  State<PlantLoader> createState() => _PlantLoaderState();
}

class _PlantLoaderState extends State<PlantLoader>
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
          final sprout = Curves.easeOut.transform(_range(.08, .25));
          final stem = Curves.easeInOut.transform(_range(.22, .55));
          final leaf = Curves.easeOutBack.transform(_range(.45, .72));
          final flower = Curves.elasticOut.transform(_range(.72, .95));

          return CustomPaint(
            painter: _PlantPainter(
              progress: _controller.value,
              sprout: sprout,
              stem: stem,
              leaf: leaf,
              flower: flower,
            ),
          );
        },
      ),
    );
  }
}

class _PlantPainter extends CustomPainter {
  final double progress;
  final double sprout;
  final double stem;
  final double leaf;
  final double flower;

  _PlantPainter({
    required this.progress,
    required this.sprout,
    required this.stem,
    required this.leaf,
    required this.flower,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 180;
    canvas.scale(s);

    _drawShadow(canvas);
    _drawPot(canvas);
    _drawSoil(canvas);
    _drawSeed(canvas);
    _drawStem(canvas);
    _drawLeaves(canvas);
    _drawFlower(canvas);
  }

  void _drawShadow(Canvas canvas) {
    canvas.drawOval(
      const Rect.fromLTWH(52, 154, 76, 10),
      Paint()..color = Colors.black.withOpacity(.22),
    );
  }

  void _drawPot(Canvas canvas) {
    final potRect = const Rect.fromLTWH(55, 108, 70, 48);

    canvas.drawRRect(
      RRect.fromRectAndRadius(potRect, const Radius.circular(18)),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFD97706), Color(0xFF92400E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(potRect),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(48, 100, 84, 18),
        const Radius.circular(18),
      ),
      Paint()..color = const Color(0xFFB45309),
    );
  }

  void _drawSoil(Canvas canvas) {
    canvas.drawOval(
      const Rect.fromLTWH(56, 102, 68, 12),
      Paint()..color = const Color(0xFF3F2A1D),
    );
  }

  void _drawSeed(Canvas canvas) {
    final seedY = 104 - (sprout * 8);

    canvas.drawOval(
      Rect.fromLTWH(84, seedY, 12, 8),
      Paint()..color = const Color(0xFF8B5E3C),
    );
  }

  void _drawStem(Canvas canvas) {
    if (stem <= 0) return;

    final stemPaint = Paint()
      ..color = const Color(0xFF22C55E)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final height = 58 * stem;

    final path = Path()
      ..moveTo(90, 104)
      ..quadraticBezierTo(
        92 + math.sin(progress * math.pi * 2) * 6,
        82,
        90,
        104 - height,
      );

    canvas.drawPath(path, stemPaint);
  }

  void _drawLeaves(Canvas canvas) {
    if (leaf <= 0) return;

    final y = 72 - (stem * 26);

    final leftLeaf = Path()
      ..moveTo(90, y)
      ..quadraticBezierTo(58 - leaf * 12, y - 10, 72 - leaf * 5, y - 26 * leaf)
      ..quadraticBezierTo(88, y - 18, 90, y);

    final rightLeaf = Path()
      ..moveTo(90, y)
      ..quadraticBezierTo(122 + leaf * 10, y - 8, 108 + leaf * 4, y - 28 * leaf)
      ..quadraticBezierTo(92, y - 18, 90, y);

    final leafPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF4ADE80), Color(0xFF16A34A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(const Rect.fromLTWH(50, 40, 80, 60));

    canvas.drawPath(leftLeaf, leafPaint);
    canvas.drawPath(rightLeaf, leafPaint);
  }

  void _drawFlower(Canvas canvas) {
    if (flower <= 0) return;

    final center = Offset(90, 48);

    final petalPaint = Paint()..color = const Color(0xFFF472B6);

    for (int i = 0; i < 6; i++) {
      final angle = (math.pi * 2 / 6) * i;

      final dx = math.cos(angle) * 14 * flower;
      final dy = math.sin(angle) * 14 * flower;

      canvas.drawCircle(
        Offset(center.dx + dx, center.dy + dy),
        8 * flower,
        petalPaint,
      );
    }

    canvas.drawCircle(
      center,
      7 * flower,
      Paint()..color = const Color(0xFFFACC15),
    );
  }

  @override
  bool shouldRepaint(covariant _PlantPainter oldDelegate) => true;
}
