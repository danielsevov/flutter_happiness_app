import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:happiness_app/app_colors.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/ui/widgets/reward_system/streak_circle_painter.dart';
import 'package:happiness_app/presentation/ui/widgets/reward_system/streak_ribbon_painter.dart';

class RewardCircle extends StatelessWidget {
  final int score;
  final IconData icon;
  final Color color;
  final String title;
  final AppLocalizations localizations;
  final int maxStreak;
  final bool isReward;

  const RewardCircle({
    Key? key,
    required this.localizations,
    required this.score,
    required this.icon,
    required this.color,
    required this.title,
    required this.maxStreak,
    required this.isReward,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double streakPercentage = score / maxStreak;

        double widgetSize =
            constraints.maxWidth < 400 ? Helper.getCircleSize(constraints) : 80;
        TextStyle textStyle = Theme.of(context)
            .textTheme
            .displayLarge!
            .copyWith(
                fontSize: Helper.getNormalTextSize(constraints),
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onBackground);
        TextStyle countStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: Helper.getBigHeadingSize(constraints), color: color);

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Ribbon using CustomPaint
              CustomPaint(
                size: Size(widgetSize, widgetSize), // adjust the size as needed
                painter: StreakRibbonPainter(
                    AppColors.primaryKabisaGreen, AppColors.ribbonColor),
              ),
              SizedBox(height: 12),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: widgetSize,
                    height: widgetSize,
                    child: CustomPaint(
                      foregroundPainter: StreakCirclePainter(
                          (streakPercentage),
                          color,
                          color.withOpacity(0.3)),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: widgetSize / 4, color: color),
                      SizedBox(height: widgetSize / 12),
                      Text(maxStreak.toString(), style: countStyle),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                title,
                style: textStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
