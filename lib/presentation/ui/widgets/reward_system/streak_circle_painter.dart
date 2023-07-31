import 'dart:math';

import 'package:flutter/material.dart';

class StreakCirclePainter extends CustomPainter {
  double currentProgress;
  Color backgroundColor;
  Color progressColor;

  StreakCirclePainter(
      this.currentProgress, this.progressColor, this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint outerCircle = Paint()
      ..strokeWidth = 10
      ..color = backgroundColor
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = 10
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    // Creating a radial gradient for the filled circle
    final Gradient gradient = RadialGradient(
      center: const Alignment(0, 0),
      radius: 0.5,
      colors: [backgroundColor, backgroundColor.withOpacity(0.3)],
      stops: [0.4, 1.0],
    );

    Rect rect = Rect.fromCircle(center: center, radius: radius);
    Paint innerCircle = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        center, radius, outerCircle); // Draws the outline of the circle
    canvas.drawCircle(center, radius, innerCircle); // Draws the filled circle

    double angle = 2 * pi * (currentProgress);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        angle, false, completeArc);

    // Adding shadow for a 3D effect
    Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 4);
    canvas.drawCircle(center, radius, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
