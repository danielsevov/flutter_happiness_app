// ignore_for_file: lines_longer_than_80_chars, avoid_multiple_declarations_per_line, always_put_required_named_parameters_first

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/presenters/weekly_retro_presenter.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/answer_text_field.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/dialogs/icon_button_guide_dialog.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/rating_level_entry.dart';

/// The form nested in the weekly retrospection page, which allows the user
/// to fill in their weekly report and validate the input.
class WeeklyRetrospectionForm extends StatefulWidget {
  // Simple constructor for the log in form instance, which takes the context screen dimensions and the business logic object.
  const WeeklyRetrospectionForm({
    super.key,
    required this.presenter,
    required this.constraints,
    required this.report,
    required this.weekNumber,
    required this.year,
  });
  final WeeklyRetrospectionPresenter presenter;
  final BoxConstraints constraints;
  final HappinessReportModel report;
  final int weekNumber;
  final int year;

  @override
  WeeklyRetrospectionFormState createState() {
    return WeeklyRetrospectionFormState();
  }
}

/// This class holds data and methods related to the log in form.
class WeeklyRetrospectionFormState extends State<WeeklyRetrospectionForm> {
  final TextEditingController _feedbackController =
          TextEditingController(),
      _insightController = TextEditingController();
  int _weeklyRating = 0;

  final _weeklyFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    setState(() {
      _weeklyRating = widget.report.happinessLevel.toInt();
      _feedbackController.text = widget.report.careForSelf ?? '';
      _insightController.text = widget.report.insight ?? '';
    });

    return Form(
      key: _weeklyFormKey,
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        localizations.weeklyQuestionOne,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.w700,
                              fontSize:
                                  Helper.getNormalTextSize(widget.constraints),
                            ),
                      ),
                    ),
                  ),
                  IconButtonGuideDialog(
                    title: localizations.weeklyQuestionOne,
                    guideline:
                        localizations.weeklyQuestionOneGuide,
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
                  RatingEntry(
                    color: Theme.of(context).colorScheme.primary,
                    icon: Icons.circle,
                    onRatingUpdate: (rating) {
                      _weeklyRating = rating.toInt();
                    },
                    constraints: widget.constraints,
                    initialValue: widget.report.happinessLevel,
                    lowValueLabel: localizations.ratingLowScore,
                    highValueLabel: localizations.ratingHighScore,
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

            //feedback text field
            AnswerTextField(
              controller: _feedbackController,
              hint: localizations.pleaseEnterText,
              icon: FontAwesomeIcons.comment,
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return localizations.incompleteAnswer;
                }
                return null;
              },
              constraints: widget.constraints,
              question: localizations.weeklyQuestionTwo,
              guide: localizations.weeklyQuestionTwoGuide,
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
              question: localizations.weeklyQuestionThree,
              guide: localizations.weeklyQuestionThreeGuide,
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
                localizations.finishWeeklyRetro,
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
                if (_weeklyFormKey.currentState!.validate()) {
                  await widget.presenter.saveChanges(
                    _weeklyRating,
                    _feedbackController.text.isEmpty
                        ? null
                        : _feedbackController.text,
                    _insightController.text.isEmpty
                        ? null
                        : _insightController.text,
                    widget.weekNumber,
                    widget.year,
                  );
                }
              },
              heroTag: 'saveWeeklyRetroButton',
            ),
          ],
        ),
      ),
    );
  }
}
