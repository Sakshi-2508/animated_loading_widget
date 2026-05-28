import 'dart:math' as math;
import 'package:flutter/material.dart';

class DeliveryLoader extends StatefulWidget {
  final double size;
  final Duration duration;

  const DeliveryLoader({
    super.key,
    this.size = 200,
    this.duration = const Duration(milliseconds: 3200),
  });

  @override
  State<DeliveryLoader> createState() => _DeliveryLoaderState();
}

class _DeliveryLoaderState extends State<DeliveryLoader>
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
          final drive = Curves.easeInOutCubic.transform(_range(.04, .72));
          final delivered = Curves.elasticOut.transform(_range(.72, .95));
          final reset = Curves.easeInOut.transform(_range(.95, 1.0));

          return CustomPaint(
            painter: _DeliveryPainter(
              progress: _controller.value,
              drive: drive * (1 - reset),
              delivered: delivered,
            ),
          );
        },
      ),
    );
  }
}

class _DeliveryPainter extends CustomPainter {
  final double progress;
  final double drive;
  final double delivered;

  _DeliveryPainter({
    required this.progress,
    required this.drive,
    required this.delivered,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 200;
    canvas.scale(s);

    _drawBackground(canvas);
    _drawRoad(canvas);
    _drawSpeedLines(canvas);

    final x = -42 + drive * 145;
    final bounce = math.sin(progress * math.pi * 14) * 2.4 * (1 - delivered);

    canvas.save();
    canvas.translate(x, bounce);
    _drawScooter(canvas);
    _drawRider(canvas);
    _drawPackage(canvas);
    canvas.restore();

    _drawDeliveredBadge(canvas);
  }

  void _drawBackground(Canvas canvas) {
    canvas.drawCircle(
      const Offset(155, 55),
      18,
      Paint()..color = const Color(0xFFFFEDD5).withOpacity(.18),
    );

    canvas.drawCircle(
      const Offset(42, 48),
      10,
      Paint()..color = Colors.white.withOpacity(.08),
    );
  }

  void _drawRoad(Canvas canvas) {
    canvas.drawOval(
      const Rect.fromLTWH(40, 152, 122, 13),
      Paint()..color = Colors.black.withOpacity(.28),
    );

    final paint = Paint()
      ..color = Colors.white.withOpacity(.25)
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;

    final offset = (progress * 40) % 40;

    for (double x = -20 - offset; x < 210; x += 44) {
      canvas.drawLine(Offset(x, 143), Offset(x + 24, 143), paint);
    }
  }

  void _drawSpeedLines(Canvas canvas) {
    if (drive <= .05 || delivered > .1) return;

    final paint = Paint()
      ..color = Colors.orangeAccent.withOpacity(.35)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 4; i++) {
      final y = 88.0 + i * 13;
      final move = (progress * 60 + i * 14) % 55;
      canvas.drawLine(Offset(18 + move, y), Offset(48 + move, y), paint);
    }
  }

  void _drawScooter(Canvas canvas) {
    final dark = Paint()..color = const Color(0xFF111827);
    final tire = Paint()..color = const Color(0xFF020617);
    final metal = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(const Offset(58, 140), 13, tire);
    canvas.drawCircle(const Offset(58, 140), 6, Paint()..color = Colors.white);

    canvas.drawCircle(const Offset(122, 140), 13, tire);
    canvas.drawCircle(const Offset(122, 140), 6, Paint()..color = Colors.white);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(54, 110, 72, 26),
        const Radius.circular(20),
      ),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFFFA726), Color(0xFFFF6D00), Color(0xFFD84315)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(const Rect.fromLTWH(54, 108, 74, 30)),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(73, 101, 36, 10),
        const Radius.circular(8),
      ),
      dark,
    );

    canvas.drawPath(
      Path()
        ..moveTo(88, 108)
        ..quadraticBezierTo(102, 86, 121, 106),
      metal,
    );

    canvas.drawLine(const Offset(121, 106), const Offset(137, 91), metal);
    canvas.drawLine(const Offset(137, 91), const Offset(147, 94), metal);

    canvas.drawCircle(
      const Offset(132, 107),
      7,
      Paint()..color = const Color(0xFFFFF7ED).withOpacity(.95),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(60, 118, 36, 9),
        const Radius.circular(20),
      ),
      Paint()..color = Colors.white.withOpacity(.25),
    );
  }

  void _drawRider(Canvas canvas) {
    final helmetPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF60A5FA), Color(0xFF2563EB)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(const Rect.fromLTWH(82, 72, 30, 30));

    canvas.drawCircle(const Offset(96, 84), 12, helmetPaint);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(87, 84, 22, 7),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFF111827).withOpacity(.75),
    );

    final bodyPaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(const Offset(94, 98), const Offset(106, 116), bodyPaint);
    canvas.drawLine(const Offset(103, 103), const Offset(124, 103), bodyPaint);
  }

  void _drawPackage(Canvas canvas) {
    final boxRect = const Rect.fromLTWH(45, 86, 34, 28);

    canvas.drawRRect(
      RRect.fromRectAndRadius(boxRect, const Radius.circular(6)),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFFDE68A), Color(0xFFD97706)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(boxRect),
    );

    final tape = Paint()
      ..color = const Color(0xFF92400E)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(62, 86), const Offset(62, 114), tape);
    canvas.drawLine(const Offset(45, 99), const Offset(79, 99), tape);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(49, 89, 13, 5),
        const Radius.circular(4),
      ),
      Paint()..color = Colors.white.withOpacity(.25),
    );
  }

  void _drawDeliveredBadge(Canvas canvas) {
    if (delivered <= 0) return;

    final center = const Offset(158, 76);

    canvas.drawCircle(
      center,
      28 * delivered,
      Paint()..color = const Color(0xFF22C55E).withOpacity(.16),
    );

    canvas.drawCircle(
      center,
      18 * delivered,
      Paint()..color = const Color(0xFF22C55E),
    );

    final check = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(149, 76)
      ..lineTo(156, 83)
      ..lineTo(168, 68);

    canvas.drawPath(path, check);

    final sparkle = Paint()..color = Colors.white.withOpacity(.8 * delivered);
    canvas.drawCircle(const Offset(132, 58), 2.5 * delivered, sparkle);
    canvas.drawCircle(const Offset(181, 90), 2.3 * delivered, sparkle);
    canvas.drawCircle(const Offset(172, 48), 1.8 * delivered, sparkle);
  }

  @override
  bool shouldRepaint(covariant _DeliveryPainter oldDelegate) => true;
}
