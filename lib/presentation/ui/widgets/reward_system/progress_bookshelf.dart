import 'dart:math';

import 'package:flutter/material.dart';
import 'package:happiness_app/app_colors.dart';
import 'package:happiness_app/presentation/ui/pages/introspection_history_page.dart';

class ProgressBookshelf extends StatelessWidget {
  final List<RewardData> rewardData;

  ProgressBookshelf({required this.rewardData});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: ProgressPainter(rewardData),
        child: Container(),
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  final List<RewardData> rewardData;
  final List<double> randomWidths;
  final List<double> randomHeights;
  final List<double> randomTilts;
  final List<double> randomOpacities;

  ProgressPainter(this.rewardData)
      : randomWidths =
            List.generate(rewardData.length, (_) => Random().nextDouble()),
        randomHeights =
            List.generate(rewardData.length, (_) => Random().nextDouble()),
        randomTilts =
            List.generate(rewardData.length, (_) => Random().nextDouble()),
        randomOpacities =
            List.generate(rewardData.length, (_) => Random().nextDouble());


  @override
  void paint(Canvas canvas, Size size) {
    if (rewardData.isEmpty) {
      // Maybe paint an empty state here or just return
      return;
    }

    if (size.height <= 0.0 || size.width <= 0.0) {
      // Maybe paint a loading state here or just return
      return;
    }

    var bookWidth = 30.0; // max book width
    var maxBooksPerShelf = max(1, size.width ~/ bookWidth); // Ensure non-zero divisor

    var totalBooksNeeded = rewardData.length;
    var totalShelvesNeeded = max(1, (totalBooksNeeded / maxBooksPerShelf).ceil()); // Ensure non-zero divisor
    var fullBookHeight = (size.height / totalShelvesNeeded) / 1.5; // Change book height here

    // Calculate the spacing between shelves
    var spacing = max(0.0, (size.height - (totalShelvesNeeded * fullBookHeight)) / (totalShelvesNeeded + 1)); // Ensure non-negative value

    // Calculate the height of the cupboard based on the total shelves and spacing
    var cupboardHeight = totalShelvesNeeded * (fullBookHeight + spacing);

    // Draw the cupboard outline
    var cupboardOutlinePaint = Paint()
      ..color = AppColors.secondaryBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15.0;

    var cupboardOutlineRect = Rect.fromLTWH(
      0,
      size.height - cupboardHeight,
      size.width,
      cupboardHeight,
    );
    canvas.drawRect(cupboardOutlineRect, cupboardOutlinePaint);

    // Draw the cupboard
    var cupboardPaint = Paint()
      ..color = AppColors.ribbonColor.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    var cupboardRect = Rect.fromLTWH(
      2,
      size.height - cupboardHeight + 2,
      size.width - 4,
      cupboardHeight - 4,
    );
    canvas.drawRect(cupboardRect, cupboardPaint);

    // Draw the shelves
    for (var i = 0; i < totalShelvesNeeded; i++) {
      var shelfTop = size.height - (i + 1) * fullBookHeight - (i + 1) * spacing;

      var shelfPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryBlue,
            AppColors.secondaryBlue,
            AppColors.ribbonColor
          ],
        ).createShader(Rect.fromLTRB(0, shelfTop, size.width, shelfTop + 5));

      var shelfRect = Rect.fromLTWH(0, shelfTop, size.width, 5);
      canvas.drawRect(shelfRect, shelfPaint);
    }

    // Draw the books
    for (var i = 0; i < totalBooksNeeded; i++) {
      var currentShelf = i ~/ maxBooksPerShelf;
      var currentBook = i % maxBooksPerShelf;

      var randomWidth = bookWidth * (0.8 + randomWidths[i] * 0.2);
      var randomHeight = fullBookHeight * (0.8 + randomHeights[i] * 0.2);
      var randomTilt = -0.1 + randomTilts[i] * 0.1;

      // Ensure that the book bottoms always touch the shelf
      var bookBase = size.height - currentShelf * (fullBookHeight + spacing);

      // Adjust the book left position to prevent overlapping
      var left = currentBook * bookWidth + 5 + (bookWidth - randomWidth) / 2;

      // Apply the random tilt
      canvas.save();
      canvas.translate(left, bookBase);
      canvas.rotate(randomTilt);

      // Draw the book
      double randomOpacity =
          0.6 + randomOpacities[i] * 0.4; // random double between 0.6 and 1.0
      var bookPaint = Paint()
        ..color = AppColors.primaryBlue.withOpacity(randomOpacity)
        ..style = PaintingStyle.fill;

      var bookRect = Rect.fromLTWH(0, -randomHeight, randomWidth, randomHeight);
      canvas.drawRect(bookRect, bookPaint);

      // Draw the 3D effect
      var effectPaint = Paint()
        ..color = AppColors.ribbonColor
            .withOpacity(randomOpacity) // deterministic color
        ..style = PaintingStyle.fill;
      var effectRect =
          Rect.fromLTRB(randomWidth - 10, -randomHeight, randomWidth, 0);
      canvas.drawRect(effectRect, effectPaint);

      // Draw the label
      final textSpan = TextSpan(
        text: "${rewardData[i].id} (${rewardData[i].number})",
        style: TextStyle(
          color: AppColors.ribbonColor,
          fontWeight: FontWeight.w700,
          fontSize: 8.0,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout();

      // Calculate the offset based on the rotated book
      final offset = Offset(bookRect.center.dx - textPainter.width / 2, bookRect.bottom - 10);

      // Apply the offset and rotate the canvas
      canvas.translate(offset.dx + 38, offset.dy - 70);
      canvas.rotate(randomTilt - 29.8);
      textPainter.paint(canvas, Offset.zero);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
