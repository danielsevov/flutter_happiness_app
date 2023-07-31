// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/base_report_body.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/answer_text.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/rating_level.dart';

/// The narrow body of the retrospection report, to be displayed on more
/// narrow screens, such as mobile screens..
class WeeklyRetrospectionReportBodyNarrow extends BaseReportBody {
  const WeeklyRetrospectionReportBodyNarrow(
      {super.key, required super.report, required super.constraints,});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),

          // week rating entry
          RatingLevel(
            icon: FontAwesomeIcons.star,
            color: Theme.of(context).colorScheme.primary,
            constraints: constraints,
            ratingLevel: report.happinessLevel.toInt(),
            ratingTitle: localizations.weeklyRating,
          ),

          // feedback entry
          AnswerText(
            icon: FontAwesomeIcons.comment,
            question: localizations.whyThisRating,
            answer: report.careForSelf ??
                localizations.questionSkipped,
            constraints: constraints,
          ),

          // insight entry
          AnswerText(
            icon: FontAwesomeIcons.lightbulb,
            question: localizations.whatHaveLearned,
            answer:
                report.insight ?? localizations.questionSkipped,
            constraints: constraints,
          ),

          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
