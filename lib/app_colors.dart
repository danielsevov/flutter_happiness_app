// ignore_for_file: lines_longer_than_80_chars, prefer_final_locals, strict_raw_type, inference_failure_on_instance_creation

import 'package:charts_common/common.dart' as charts;
import 'package:flutter/material.dart';

class AppColors {

  static const Color primaryKabisaGreen = Color.fromRGBO(65, 195, 135, 1);
  static const Color secondaryKabisaGreen = Color.fromRGBO(80, 210, 150, 1);
  static const Color kabisaBlack = Color.fromRGBO(83, 92, 97, 1);

  static const Color kabisaWhite = Color.fromRGBO(247, 249, 250, 1);
  static const Color kabisaCallToActionYellow = Color.fromRGBO(255, 222, 92, 1);
  static const Color kabisaGrey = Color.fromRGBO(156, 167, 173, 1);
  static const Color happinessColor = primaryKabisaGreen;
  static const Color sadnessColor = Color.fromRGBO(88, 146, 204, 1);
  static const Color angerColor = Color.fromRGBO(240, 80, 60, 1);
  static const Color fearColor = Color.fromRGBO(164, 91, 195, 1);

  static const Color highStreakColor = Color.fromRGBO(255, 215, 0, 1);  // Gold color
  static const Color mediumStreakColor = Color.fromRGBO(192, 192, 192, 1);  // Silver color
  static const Color lowStreakColor = Color.fromRGBO(205, 127, 50, 1);  // Bronze color
  static const Color veryLowStreakColor = Color.fromRGBO(150, 62, 29, 1.0); // Rusty red color
  static const Color minimalStreakColor = Color.fromRGBO(82, 82, 82, 1.0); // Gunmetal gray color


  static const Color ribbonColor = Color.fromRGBO(0, 77, 64, 1);  // A darker shade of teal

  /// Function used for converting material color to chart color
  static charts.Color convertColorToChartsColor(Color color) => charts.Color(
        r: color.red,
        g: color.green,
        b: color.blue,
        a: color.alpha,
      );
}
