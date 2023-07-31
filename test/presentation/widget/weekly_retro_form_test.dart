// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/presenters/weekly_retro_presenter.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/answer_text_field.dart';
import 'package:happiness_app/presentation/ui/widgets/weekly_retrospection/weekly_retro_form.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../localizations_injection.dart';
import 'weekly_retro_form_test.mocks.dart';


@GenerateMocks([WeeklyRetrospectionPresenter])
void main() {

  testWidgets('WeeklyRetroForm test constructor with empty report', (tester) async {
    final presenter = MockWeeklyRetrospectionPresenter();
    final report = HappinessReportModel.empty();

    final form =
    WeeklyRetrospectionForm(presenter: presenter, constraints: const BoxConstraints(maxHeight: 1200, maxWidth: 1200), report: report, weekNumber: Helper.getWeekNumber(DateTime.now()),
        year: DateTime.now().year,);

    await tester.pumpWidget(LocalizationsInj(
      locale: const Locale('en'),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: form,),
        ),),),);

    await tester.pumpAndSettle();

    expect(find.text('1. Overall how would I rate this (past) week?'), findsOneWidget);
    expect(find.text("2. Why did I choose that rating for my week's experience?"), findsOneWidget);
    expect(find.text('3. What have I learned this week?'), findsOneWidget);

    expect(find.text('very unhappy'), findsOneWidget);
    expect(find.text('very happy'), findsOneWidget);

    final accomplishmentsTextField =
    find.byWidgetPredicate((widget) => widget is AnswerTextField && widget.icon == FontAwesomeIcons.comment);
    expect(accomplishmentsTextField, findsOneWidget);

    final insightTextField = find.byWidgetPredicate((widget) => widget is AnswerTextField && widget.icon == FontAwesomeIcons.lightbulb);
    expect(insightTextField, findsOneWidget);
  });

  testWidgets('WeeklyRetrospectionForm test constructor with non-empty report', (tester) async {
    final presenter = MockWeeklyRetrospectionPresenter();
    final report = HappinessReportModel.empty()
      ..careForSelf = 'Self care'
      ..insight = 'Other care';

    final form =
    WeeklyRetrospectionForm(presenter: presenter, constraints: const BoxConstraints(maxHeight: 1200, maxWidth: 1200), report: report, weekNumber: Helper.getWeekNumber(DateTime.now()),
      year: DateTime.now().year,);

    await tester.pumpWidget(LocalizationsInj(
      locale: const Locale('en'),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: form,),
        ),),),);

    await tester.pumpAndSettle();

    expect(find.text('Self care'), findsOneWidget);
    expect(find.text('Other care'), findsOneWidget);
  });

  testWidgets('WeeklyRetrospectionForm test question guide', (tester) async {
    final presenter = MockWeeklyRetrospectionPresenter();

    final report = HappinessReportModel.empty();

    final form =
    WeeklyRetrospectionForm(presenter: presenter, constraints: const BoxConstraints(maxHeight: 1200, maxWidth: 1200), report: report, weekNumber: Helper.getWeekNumber(DateTime.now()),
      year: DateTime.now().year,);

    await tester.pumpWidget(LocalizationsInj(
      locale: const Locale('en'),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                form,
              ],
            ),),
        ),),),);

    await tester.pumpAndSettle();

    expect(find.textContaining('Please take a moment to reflect on your experience this week.'), findsNothing);

    await tester.tap(find.byIcon(CupertinoIcons.info).first);
    await tester.pumpAndSettle();

    expect(find.textContaining('Please take a moment to reflect on your experience this week.'), findsOneWidget);

    await tester.dragUntilVisible(find.text('CLOSE'), find.byType(SingleChildScrollView), const Offset(1, 1));
    await tester.tap(find.text('CLOSE'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Please take a moment to reflect on your experience this week.'), findsNothing);
  });

  testWidgets('WeeklyRetrospectionForm test validator fails', (tester) async {
    final presenter = MockWeeklyRetrospectionPresenter();

    final report = HappinessReportModel.empty();

    final form =
    WeeklyRetrospectionForm(presenter: presenter, constraints: const BoxConstraints(maxHeight: 1200, maxWidth: 1200), report: report, weekNumber: Helper.getWeekNumber(DateTime.now()),
      year: DateTime.now().year,);

    await tester.pumpWidget(LocalizationsInj(
      locale: const Locale('en'),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: form,),
        ),),),);

    await tester.pumpAndSettle();

    // enter form values
    await tester.tap(find.byType(RatingBar).first);

    // submit form
    await tester.dragUntilVisible(find.text('Finish Retrospection'), find.byType(SingleChildScrollView), const Offset(1, 1));
    await tester.tap(find.text('Finish Retrospection'));

    // verify values were saved
    verifyNever(presenter.saveChanges(any, any, any, any, any));
  });

  testWidgets('WeeklyRetrospectionForm test validator doesnt trigger when fields are disabled', (tester) async {
    final presenter = MockWeeklyRetrospectionPresenter();

    final report = HappinessReportModel.empty();

    final form =
    WeeklyRetrospectionForm(presenter: presenter, constraints: const BoxConstraints(maxHeight: 1200, maxWidth: 1200), report: report, weekNumber: Helper.getWeekNumber(DateTime.now()),
      year: DateTime.now().year,);

    await tester.pumpWidget(LocalizationsInj(
      locale: const Locale('en'),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: form,),
        ),),),);

    await tester.pumpAndSettle();

    // disable accomplishments field
    await tester.dragUntilVisible(find.text('Skip question').first, find.byType(SingleChildScrollView), const Offset(1, 1));
    await tester.tap(find.text('Skip question').first);

    // enter other form values
    await tester.enterText(find.widgetWithIcon(AnswerTextField, FontAwesomeIcons.lightbulb), 'Insight');

    // submit form
    await tester.dragUntilVisible(find.text('Finish Retrospection'), find.byType(SingleChildScrollView), const Offset(1, 1));
    await tester.tap(find.text('Finish Retrospection'));

    // verify values were saved
    verify(presenter.saveChanges(any, any, any, any, any)).called(1);
  });

  testWidgets('WeeklyRetrospectionForm test validator successful', (tester) async {
    final presenter = MockWeeklyRetrospectionPresenter();

    final report = HappinessReportModel.empty();

    final form =
    WeeklyRetrospectionForm(presenter: presenter, constraints: const BoxConstraints(maxHeight: 1200, maxWidth: 1200), report: report, weekNumber: Helper.getWeekNumber(DateTime.now()),
      year: DateTime.now().year,);

    await tester.pumpWidget(LocalizationsInj(
      locale: const Locale('en'),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: form,),
        ),),),);

    await tester.pumpAndSettle();

    // enter form values
    await tester.tap(find.byType(RatingBar).first);
    await tester.enterText(find.widgetWithIcon(AnswerTextField, FontAwesomeIcons.comment), 'Accomplishments');
    await tester.enterText(find.widgetWithIcon(AnswerTextField, FontAwesomeIcons.lightbulb), 'My new Insight');

    // submit form
    await tester.dragUntilVisible(find.text('Finish Retrospection'), find.byType(SingleChildScrollView), const Offset(1, 1));
    await tester.tap(find.text('Finish Retrospection'));

    // verify values were saved
    verify(presenter.saveChanges(any, any, any, any, any)).called(1);
  });

  testWidgets('WeeklyRetrospectionForm test text capitalization', (tester) async {
    final presenter = MockWeeklyRetrospectionPresenter();

    final report = HappinessReportModel.empty();

    final form =
    WeeklyRetrospectionForm(presenter: presenter, constraints: const BoxConstraints(maxHeight: 1200, maxWidth: 1200), report: report, weekNumber: Helper.getWeekNumber(DateTime.now()),
      year: DateTime.now().year,);

    await tester.pumpWidget(LocalizationsInj(
      locale: const Locale('en'),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: form,),
        ),),),);

    await tester.pumpAndSettle();

    // enter form values
    await tester.enterText(find.widgetWithIcon(AnswerTextField, FontAwesomeIcons.comment), 'those are my accomplishments. i think they are great.');
    await tester.enterText(find.widgetWithIcon(AnswerTextField, FontAwesomeIcons.lightbulb), 'those are my insights. i think they are great.');

    // check if they are capitalized
    expect(find.text('Those are my accomplishments. I think they are great.'), findsOneWidget);
    expect(find.text('Those are my insights. I think they are great.'), findsOneWidget);
  });
}
