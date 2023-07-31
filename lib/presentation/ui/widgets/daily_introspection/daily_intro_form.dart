// ignore_for_file: lines_longer_than_80_chars, avoid_multiple_declarations_per_line, always_put_required_named_parameters_first

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:happiness_app/app_colors.dart';
import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/presenters/daily_intro_presenter.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/answer_text_field.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/dialogs/icon_button_guide_dialog.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/feeling_level_entry.dart';

/// The form nested in the daily introspection page, which allows the user
/// to fill in their daily report and validate the input.
class DailyIntrospectionForm extends StatefulWidget {
  // Simple constructor for the log in form instance, which takes the context screen dimensions and the business logic object.
  const DailyIntrospectionForm({
    super.key,
    required this.presenter,
    required this.constraints,
    required this.report,
    required this.date,
  });
  final DailyIntrospectionPresenter presenter;
  final BoxConstraints constraints;
  final HappinessReportModel report;
  final String date;

  @override
  DailyIntrospectionFormState createState() {
    return DailyIntrospectionFormState();
  }
}

/// This class holds data and methods related to the log in form.
class DailyIntrospectionFormState extends State<DailyIntrospectionForm> {
  final TextEditingController _accomplishmentsController =
          TextEditingController(),
      _contributionsController = TextEditingController(),
      _insightController = TextEditingController();
  double _happinessLevel = 0, _sadnessLevel = 0, _angerLevel = 0, _fearLevel = 0;

  final _dailyFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    setState(() {
      _happinessLevel = widget.report.happinessLevel;
      _sadnessLevel = widget.report.sadnessLevel;
      _fearLevel = widget.report.fearLevel;
      _angerLevel = widget.report.angerLevel;
      _accomplishmentsController.text = widget.report.careForSelf ?? '';
      _contributionsController.text = widget.report.careForOthers ?? '';
      _insightController.text = widget.report.insight ?? '';
    });

    return Form(
      key: _dailyFormKey,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(
              width: widget.constraints.maxWidth < 800
                  ? widget.constraints.maxWidth
                  : 800,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      localizations.dailyQuestionOne,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.w700,
                            fontSize:
                                Helper.getNormalTextSize(widget.constraints),
                          ),
                    ),
                  ),
                  IconButtonGuideDialog(
                    title: localizations.dailyQuestionOne,
                    guideline:
                        localizations.dailyQuestionOneGuide,
                    constraints: widget.constraints, close: localizations.close,
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),

                  //happiness level
                  FeelingLevelEntry(
                    feeling: localizations.happiness,
                    color: AppColors.happinessColor,
                    icon: FontAwesomeIcons.faceLaughBeam,
                    onRatingUpdate: (rating) {
                      _happinessLevel = rating;
                    },
                    constraints: widget.constraints,
                    initialValue: widget.report.happinessLevel,
                    hint: localizations.happinessHint,
                    lowValueLabel: localizations.happinessLowScore,
                    highValueLabel: localizations.happinessHighScore,
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  //anger level
                  FeelingLevelEntry(
                    feeling: localizations.anger,
                    color: AppColors.angerColor,
                    icon: FontAwesomeIcons.faceAngry,
                    onRatingUpdate: (rating) {
                      _angerLevel = rating;
                    },
                    constraints: widget.constraints,
                    initialValue: widget.report.angerLevel,
                    hint: localizations.angerHint,
                    lowValueLabel: localizations.angerLowScore,
                    highValueLabel: localizations.angerHighScore,
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  //fear level
                  FeelingLevelEntry(
                    feeling: localizations.fear,
                    color: AppColors.fearColor,
                    icon: FontAwesomeIcons.faceGrimace,
                    onRatingUpdate: (rating) {
                      _fearLevel = rating;
                    },
                    constraints: widget.constraints,
                    initialValue: widget.report.fearLevel,
                    hint: localizations.fearHint,
                    lowValueLabel: localizations.fearLowScore,
                    highValueLabel: localizations.fearHighScore,
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  //sadness level
                  FeelingLevelEntry(
                    feeling: localizations.sadness,
                    color: AppColors.sadnessColor,
                    icon: FontAwesomeIcons.faceSadTear,
                    onRatingUpdate: (rating) {
                      _sadnessLevel = rating;
                    },
                    constraints: widget.constraints,
                    initialValue: widget.report.sadnessLevel,
                    hint: localizations.sadnessHint,
                    lowValueLabel: localizations.sadnessLowScore,
                    highValueLabel: localizations.sadnessHighScore,
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            SizedBox(
              width: widget.constraints.maxWidth < 800
                  ? widget.constraints.maxWidth
                  : 800,
              child: Divider(
                color: Theme.of(context).colorScheme.primary,
                thickness: 1,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            //accomplishments text field
            AnswerTextField(
              controller: _accomplishmentsController,
              hint: localizations.pleaseEnterText,
              icon: FontAwesomeIcons.heart,
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return localizations.incompleteAnswer;
                }
                return null;
              },
              constraints: widget.constraints,
              question: localizations.dailyQuestionTwo,
              guide: localizations.dailyQuestionTwoGuide,
              isNewReport: widget.report.id == null,
            ),

            const SizedBox(
              height: 20,
            ),

            SizedBox(
              width: widget.constraints.maxWidth < 800
                  ? widget.constraints.maxWidth
                  : 800,
              child: Divider(
                color: Theme.of(context).colorScheme.primary,
                thickness: 1,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            //contributions text field
            AnswerTextField(
              controller: _contributionsController,
              hint: localizations.pleaseEnterText,
              icon: FontAwesomeIcons.handshake,
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return localizations.incompleteAnswer;
                }
                return null;
              },
              constraints: widget.constraints,
              question: localizations.dailyQuestionThree,
              guide: localizations.dailyQuestionThreeGuide,
              isNewReport: widget.report.id == null,
            ),

            const SizedBox(
              height: 20,
            ),

            SizedBox(
              width: widget.constraints.maxWidth < 800
                  ? widget.constraints.maxWidth
                  : 800,
              child: Divider(
                color: Theme.of(context).colorScheme.primary,
                thickness: 1,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            //insight text field
            AnswerTextField(
              controller: _insightController,
              hint: localizations.pleaseEnterText,
              icon: FontAwesomeIcons.lightbulb,
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return localizations.incompleteAnswer;
                }
                return null;
              },
              constraints: widget.constraints,
              question: localizations.dailyQuestionFour,
              guide: localizations.dailyQuestionFourGuide,
              isNewReport: widget.report.id == null,
            ),

            const SizedBox(
              height: 20,
            ),

            SizedBox(
              width: widget.constraints.maxWidth < 800
                  ? widget.constraints.maxWidth
                  : 800,
              child: Divider(
                color: Theme.of(context).colorScheme.primary,
                thickness: 1,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            //save report button
            FloatingActionButton.extended(
              backgroundColor: Theme.of(context).colorScheme.primary,
              label: Text(
                localizations.saveReport,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: Helper.getButtonTextSize(widget.constraints),
                    ),
              ),
              icon: Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.background,
                size: Helper.getIconSize(widget.constraints),
              ),
              onPressed: () async {
                if (_dailyFormKey.currentState!.validate()) {
                  await widget.presenter.saveChanges(
                    _happinessLevel,
                    _sadnessLevel,
                    _angerLevel,
                    _fearLevel,
                    _accomplishmentsController.text.isEmpty
                        ? null
                        : _accomplishmentsController.text,
                    _contributionsController.text.isEmpty
                        ? null
                        : _contributionsController.text,
                    _insightController.text.isEmpty
                        ? null
                        : _insightController.text,
                    widget.date,
                  );
                }
              },
              heroTag: 'saveDailyIntrospectionButton',
            ),
          ],
        ),
      ),
    );
  }
}
