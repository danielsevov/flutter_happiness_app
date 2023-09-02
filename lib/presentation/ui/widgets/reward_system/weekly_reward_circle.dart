import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:happiness_app/app_colors.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/ui/widgets/reward_system/reward_circle.dart';
import 'package:happiness_app/presentation/ui/widgets/reward_system/streak_circle_painter.dart';
import 'package:happiness_app/presentation/ui/widgets/reward_system/streak_ribbon_painter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeeklyRewardCircle extends StatelessWidget {
  final int streak;
  final bool isWeekly;
  final bool mini;
  final AppLocalizations localizations;

  const WeeklyRewardCircle({
    Key? key,
    required this.streak,
    required this.isWeekly,
    required this.localizations, required this.mini,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<int> maxes = !isWeekly
        ? [1, 3, 5, 7]
        : [1, 2, 3, 4];

    double maxStreak =
    maxes.last.toDouble(); // Default to the largest value
    for (int max in maxes.reversed) {
      if (streak < max) {
        maxStreak = max.toDouble();
      } else {
        break;
      }
    }

    if (maxes.contains(streak) && !mini) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final prefs = await SharedPreferences.getInstance();
        final rewardShownKey = isWeekly ? '${DateTime.now().year}${DateTime.now().month}received_award_${isWeekly}_$streak' : '${DateTime.now().year}${Helper.getWeekNumber(DateTime.now())}received_award_${isWeekly}_$streak';

        if (prefs.getBool(rewardShownKey).toString() != 'true') {
          showRewardPopup(context, determineCircleColor(maxStreak.toInt() - 1, context, maxes));
          await prefs.setBool(rewardShownKey, true);
        }
      });
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        IconData streakIcon;

        String streakTitle = isWeekly
                    ? streak < maxes.last ? localizations.streakWeeks(streak,
            (maxStreak - streak).toInt()) : localizations.streakWeeksSurpassed(streak,)
                    : streak < maxes.last ? localizations.streakDays(streak,
            (maxStreak - streak).toInt()) : localizations.streakSurpassed(streak,);

        if (isWeekly) {
          streakIcon = FontAwesomeIcons.calendarWeek;
        } else {
          streakIcon = FontAwesomeIcons.calendarDay;
        }

        double streakPercentage = streak < maxStreak ? streak / maxStreak : 1;

        double widgetSize = Helper.getCircleSize(constraints);
        Color circleColor = determineCircleColor(maxStreak.toInt(), context,
            maxes); // Determine the color based on streakPercentage
        TextStyle textStyle = Theme.of(context)
            .textTheme
            .displayLarge!
            .copyWith(
                fontSize: Helper.getNormalTextSize(constraints),
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onBackground);
        TextStyle countStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: Helper.getSmallHeadingSize(constraints) * 1.2,
            fontWeight: FontWeight.w900,
            color: circleColor);

        return Column(
          children: [
            // Ribbon using CustomPaint
            CustomPaint(
              size: Size(widgetSize, widgetSize), // adjust the size as needed
              painter: StreakRibbonPainter(AppColors.primaryBlue, AppColors.ribbonColor),
            ),
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
                        color: determineCircleColor(maxStreak.toInt(), context, maxes)),
                    SizedBox(height: widgetSize/12),
                    Text(
                        streak >= maxStreak ? '${maxStreak.toInt()}' : '${streak.toInt()} / ${maxStreak.toInt()}',
                        style: countStyle),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            mini ? SizedBox() : Text(
              streakTitle,
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }

  Color determineCircleColor(
      int maxStreak, BuildContext context, List<int> maxes) {
    if (maxStreak > maxes[2]) {
      return AppColors
          .highStreakColor; // High streak percentage, use purple color.
    } else if (maxStreak == maxes[2]) {
      return AppColors
          .mediumStreakColor; // Medium streak percentage, use primary color.
    } else if (maxStreak == maxes[1]) {
      return AppColors
          .lowStreakColor; // Medium streak percentage, use primary color.
    } else {
      return AppColors
          .minimalStreakColor; // Low streak percentage, use secondary color.
    }
  }

  void showRewardPopup(BuildContext context, Color color) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context)
          .modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child) {
        // transition to use
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 300, // set minimum width
                minHeight: 300, // set minimum height
              ),
              child: AlertDialog(
                title: Text('Congratulations!'),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, // Set this
                  children: [
                    Text('You have unlocked a reward!'),
                    SizedBox(height: 20),
                    SizedBox(
                        width: 300,
                        height: 300,
                        child: RewardCircle(
                          localizations: localizations,
                          score: streak,
                          maxStreak: streak,
                          icon: isWeekly ? FontAwesomeIcons.calendarWeek : FontAwesomeIcons.calendarDay,
                          color: determineCircleColor(streak, context, !isWeekly
                              ? [1, 3, 5, 7]
                              : [1, 2, 3, 4]),
                          title: '',
                          isReward: true,
                        )
                    )
                  ],
                ),
                actions: [
                  TextButton(
                    child: Text('Accept'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}





