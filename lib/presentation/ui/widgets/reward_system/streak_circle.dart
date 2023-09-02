import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:happiness_app/app_colors.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/ui/widgets/reward_system/streak_circle_painter.dart';
import 'package:happiness_app/presentation/ui/widgets/reward_system/streak_ribbon_painter.dart';

class StreakCircle extends StatelessWidget {
  final int streak;
  final bool isWeekly;
  final AppLocalizations localizations;
  final bool mini;
  final bool isRewardWidget;
  final int? index;

  const StreakCircle({
    Key? key,
    required this.streak,
    required this.isWeekly,
    required this.localizations,
    required this.mini,
    required this.isRewardWidget,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<int> maxes = !isWeekly
        ? [7, 30, 100, 365, 1000]
        : [4, 12, 24, 52, 100];

    double maxStreak =
    maxes.last.toDouble(); // Default to the largest value
    for (int max in maxes.reversed) {
      if (streak < max) {
        maxStreak = max.toDouble();
      } else {
        break;
      }
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        IconData streakIcon;

        if(isRewardWidget) {
          maxStreak = maxes[index!].toDouble();
        }

        String streakTitle = mini
            ? isWeekly
                ? localizations.weeklyStreak
                : localizations.dailyStreak
            : maxStreak != maxes.last
                ? isWeekly
                    ? localizations.streakWeeks(streak,
                        (maxStreak - streak).toInt())
                    : localizations.streakDays(streak,
                        (maxStreak - streak).toInt())
                : isWeekly
                    ? localizations.streakWeeksSurpassed(
                        streak)
                    : localizations.streakSurpassed(
                        streak);

        if (isWeekly) {
          streakIcon = FontAwesomeIcons.calendarWeek;
        } else {
          streakIcon = FontAwesomeIcons.calendarDay;
        }

        double streakPercentage =
            maxStreak != maxes.last || isRewardWidget ? streak / maxStreak : 1;


        double widgetSize = Helper.getCircleSize(constraints);
        Color circleColor = Colors.black; // Determine the color based on streakPercentage
        TextStyle textStyle = Theme.of(context)
            .textTheme
            .displayLarge!
            .copyWith(
                fontSize: !mini
                    ? Helper.getNormalTextSize(constraints)
                    : Helper.getSmallHeadingSize(constraints),
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onBackground);
        TextStyle countStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: !mini ? Helper.getSmallHeadingSize(constraints) * 1.2 : Helper.getNormalTextSize(constraints),
            color: circleColor);

        return Column(
          children: [
            // Ribbon using CustomPaint
            !mini ? CustomPaint(
              size: Size(widgetSize, widgetSize), // adjust the size as needed
              painter: StreakRibbonPainter(AppColors.primaryBlue, AppColors.ribbonColor),
            ) : SizedBox(),
            SizedBox(height: 12),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: widgetSize,
                  height: widgetSize,
                  child: CustomPaint(
                    foregroundPainter: StreakCirclePainter(streakPercentage,
                        circleColor, circleColor.withOpacity(0.3)),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(streakIcon,
                        size: widgetSize / 4,
                        color: circleColor),
                    SizedBox(height: widgetSize/12),
                    Text(
                        '${streak.toInt()} / ${maxStreak.toInt()}',
                        style: countStyle),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            !isRewardWidget ? Text(
              streakTitle,
              style: textStyle,
              textAlign: TextAlign.center,
            ) : SizedBox(),
          ],
        );
      },
    );
  }
}





