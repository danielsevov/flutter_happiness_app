// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:happiness_app/app_colors.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/base_report_body.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/answer_text.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/feeling_level.dart';

/// The narrow body of the introspection report, to be displayed on more
/// narrow screens, such as mobile screens..
class DailyIntrospectionReportBodyNarrow extends BaseReportBody {
  const DailyIntrospectionReportBodyNarrow(
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

          // happiness level entry
          FeelingLevel(
            icon: FontAwesomeIcons.faceLaughBeam,
            color: AppColors.happinessColor,
            constraints: constraints,
            feelingLevel: report.happinessLevel.toInt(),
            feeling: localizations.happiness,
          ),

          // anger level entry
          FeelingLevel(
            icon: FontAwesomeIcons.faceAngry,
            color: AppColors.angerColor,
            constraints: constraints,
            feelingLevel: report.angerLevel.toInt(),
            feeling: localizations.anger,
          ),

          // fear level entry
          FeelingLevel(
            icon: FontAwesomeIcons.faceGrimace,
            color: AppColors.fearColor,
            constraints: constraints,
            feelingLevel: report.fearLevel.toInt(),
            feeling: localizations.fear,
          ),

          // sadness level entry
          FeelingLevel(
            icon: FontAwesomeIcons.faceSadTear,
            color: AppColors.sadnessColor,
            constraints: constraints,
            feelingLevel: report.sadnessLevel.toInt(),
            feeling: localizations.sadness,
          ),

          // care for self entry
          AnswerText(
            icon: FontAwesomeIcons.heart,
            question: localizations.dailyReportQuestionTwo,
            answer: report.careForSelf ??
                localizations.questionSkipped,
            constraints: constraints,
          ),

          // care for others entry
          AnswerText(
            icon: FontAwesomeIcons.handshake,
            question: localizations.dailyReportQuestionThree,
            answer: report.careForOthers ??
                localizations.questionSkipped,
            constraints: constraints,
          ),

          // insight entry
          AnswerText(
            icon: FontAwesomeIcons.lightbulb,
            question: localizations.dailyReportQuestionFour,
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
