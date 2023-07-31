import 'dart:math';

import 'package:flutter/material.dart';

class StreakRibbonPainter extends CustomPainter {
  final Color primaryColor;
  final Color darkTealColor;

  StreakRibbonPainter(this.primaryColor, this.darkTealColor);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Gradient gradient = RadialGradient(
      center: const Alignment(0, 0), // near the top right
      radius: 0.5,
      colors: [primaryColor, darkTealColor], // changing this to radial gradient
      stops: [0.4, 1.0],
    );
    final paint = Paint();
    paint.shader = gradient.createShader(rect);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 12;

    // Drawing the metal chain loop
    final chainPaint = Paint()
      ..color = Colors.grey[600]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    final chainCircle = Rect.fromCircle(center: Offset(size.width / 2, size.height + 2), radius: 8);
    canvas.drawArc(chainCircle, 0, 2 * pi, false, chainPaint);

    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2 - 5, size.height - 5);
    path.lineTo(size.width / 2 + 5, size.height - 5);
    path.lineTo(size.width, 0);

    // Adding glow
    Paint glowPaint = Paint()
      ..color = darkTealColor // customizable color and opacity
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20 // customizable stroke width
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 4);
    canvas.drawPath(path, glowPaint);

    // Drawing the ribbon
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(StreakRibbonPainter oldDelegate) {
    // repaint if old color data is different from new data
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.darkTealColor != darkTealColor;
  }
}
