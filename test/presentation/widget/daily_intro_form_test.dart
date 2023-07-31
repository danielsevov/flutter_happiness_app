// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/presentation/presenters/daily_intro_presenter.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/daily_intro_form.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/answer_text_field.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../localizations_injection.dart';
import 'daily_intro_form_test.mocks.dart';


@GenerateMocks([DailyIntrospectionPresenter])
void main() {

  testWidgets('DailyIntrospectionForm test constructor with empty report', (tester) async {
      final presenter = MockDailyIntrospectionPresenter();
      final report = HappinessReportModel.empty();

      final form =
          DailyIntrospectionForm(presenter: presenter, constraints: const BoxConstraints(maxHeight: 1200, maxWidth: 1200), report: report, date: DateFormat('yyyy-MM-dd').format(DateTime.now()),);

      await tester.pumpWidget(LocalizationsInj(
          locale: const Locale('en'),
          child: Scaffold(
              body: Center(
                child: SingleChildScrollView(
                    child: form,),
              ),),),);

      await tester.pumpAndSettle();

      expect(find.text('1. How are you feeling today?'), findsOneWidget);
      expect(find.text('Happiness'), findsOneWidget);
      expect(find.text('Sadness'), findsOneWidget);
      expect(find.text('Anger'), findsOneWidget);
      expect(find.text('Fear'), findsOneWidget);
      expect(find.text('2. What have you done for yourself today?'), findsOneWidget);
      expect(find.text('3. What have you done for others today?'), findsOneWidget);
      expect(find.text('4. What is your insight for the day?'), findsOneWidget);

      expect(find.text('not happy'), findsOneWidget);
      expect(find.text('very happy'), findsOneWidget);
      expect(find.text('not sad'), findsOneWidget);
      expect(find.text('very sad'), findsOneWidget);
      expect(find.text('not angry'), findsOneWidget);
      expect(find.text('very angry'), findsOneWidget);
      expect(find.text('no fear'), findsOneWidget);
      expect(find.text('very frightened'), findsOneWidget);

      final accomplishmentsTextField =
      find.byWidgetPredicate((widget) => widget is AnswerTextField && widget.icon == FontAwesomeIcons.heart);
      expect(accomplishmentsTextField, findsOneWidget);

      final contributionsTextField =
      find.byWidgetPredicate((widget) => widget is AnswerTextField && widget.icon == FontAwesomeIcons.handshake);
      expect(contributionsTextField, findsOneWidget);

      final insightTextField = find.byWidgetPredicate((widget) => widget is AnswerTextField && widget.icon == FontAwesomeIcons.lightbulb);
      expect(insightTextField, findsOneWidget);
  });

  testWidgets('DailyIntrospectionForm test emotion hints', (tester) async {
    final presenter = MockDailyIntrospectionPresenter();
    final report = HappinessReportModel.empty();

    final form =
    DailyIntrospectionForm(presenter: presenter, constraints: const BoxConstraints(maxHeight: 1200, maxWidth: 1200), report: report, date: DateFormat('yyyy-MM-dd').format(DateTime.now()),);

    await tester.pumpWidget(LocalizationsInj(
      locale: const Locale('en'),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: form,),
        ),),),);

    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(FontAwesomeIcons.faceLaughBeam));
    await tester.pumpAndSettle();
    expect(find.textContaining('Think about emotions like contentment, joy, and elation.'), findsOneWidget);

    await tester.dragUntilVisible(find.byIcon(FontAwesomeIcons.faceAngry), find.byType(SingleChildScrollView), const Offset(1, 1));

    await tester.tap(find.byIcon(FontAwesomeIcons.faceAngry));
    await tester.pumpAndSettle();
    expect(find.textContaining('Think about emotions like frustration, annoyance, and indignation.'), findsOneWidget);

    await tester.dragUntilVisible(find.byIcon(FontAwesomeIcons.faceGrimace), find.byType(SingleChildScrollView), const Offset(1, 1));

    await tester.tap(find.byIcon(FontAwesomeIcons.faceGrimace));
    await tester.pumpAndSettle();
    expect(find.textContaining('Think about emotions like anxiety, apprehension, and terror.'), findsOneWidget);

    await tester.dragUntilVisible(find.byIcon(FontAwesomeIcons.faceSadTear), find.byType(SingleChildScrollView), const Offset(1, 1));

    await tester.tap(find.byIcon(FontAwesomeIcons.faceSadTear));
    await tester.pumpAndSettle();
    expect(find.textContaining('Think about emotions like grief, sorrow, and melancholy.'), findsOneWidget);
  });

  testWidgets('DailyIntrospectionForm test constructor with non-empty report', (tester) async {
    final presenter = MockDailyIntrospectionPresenter();
    final report = HappinessReportModel.empty()
    ..careForSelf = 'Self care'
    ..careForOthers = 'Other care';

    final form =
    DailyIntrospectionForm(presenter: presenter, constraints: const BoxConstraints(maxHeight: 1200, maxWidth: 1200), report: report, date: DateFormat('yyyy-MM-dd').format(DateTime.now()),);

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

  testWidgets('DailyIntrospectionForm test question guide', (tester) async {
    final presenter = MockDailyIntrospectionPresenter();

    final report = HappinessReportModel.empty();

    final form =
    DailyIntrospectionForm(presenter: presenter, constraints: const BoxConstraints(maxHeight: 1200, maxWidth: 1200), report: report, date: DateFormat('yyyy-MM-dd').format(DateTime.now()),);

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

    expect(find.textContaining('This useful tool is designed to help you track and reflect on your emotional state.'), findsNothing);

    await tester.tap(find.byIcon(CupertinoIcons.info).first);
    await tester.pumpAndSettle();

    expect(find.textContaining('This useful tool is designed to help you track and reflect on your emotional state.'), findsOneWidget);

    await tester.dragUntilVisible(find.text('CLOSE'), find.byType(SingleChildScrollView), const Offset(1, 1));
    await tester.tap(find.text('CLOSE'));
    await tester.pumpAndSettle();

    expect(find.textContaining('This useful tool is designed to help you track and reflect on your emotional state.'), findsNothing);
  });

  testWidgets('DailyIntrospectionForm test validator fails', (tester) async {
    final presenter = MockDailyIntrospectionPresenter();

    final report = HappinessReportModel.empty();

    final form =
    DailyIntrospectionForm(presenter: presenter, constraints: const BoxConstraints(maxHeight: 1200, maxWidth: 1200), report: report, date: DateFormat('yyyy-MM-dd').format(DateTime.now()),);

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
    await tester.tap(find.byType(RatingBar).at(1));
    await tester.tap(find.byType(RatingBar).at(2));
    await tester.tap(find.byType(RatingBar).last);

    // submit form
    await tester.dragUntilVisible(find.text('Finish Introspection'), find.byType(SingleChildScrollView), const Offset(1, 1));
    await tester.tap(find.text('Finish Introspection'));

    // verify values were saved
    verifyNever(presenter.saveChanges(any, any, any, any, any, any, any, any));
  });

  testWidgets('DailyIntrospectionForm test validator doesnt trigger when fields are disabled', (tester) async {
    final presenter = MockDailyIntrospectionPresenter();

    final report = HappinessReportModel.empty();

    final form =
    DailyIntrospectionForm(presenter: presenter, constraints: const BoxConstraints(maxHeight: 1200, maxWidth: 1200), report: report, date: DateFormat('yyyy-MM-dd').format(DateTime.now()),);

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
    await tester.enterText(find.widgetWithIcon(AnswerTextField, FontAwesomeIcons.handshake), 'Contributions');
    await tester.enterText(find.widgetWithIcon(AnswerTextField, FontAwesomeIcons.lightbulb), 'Insight');

    // submit form
    await tester.dragUntilVisible(find.text('Finish Introspection'), find.byType(SingleChildScrollView), const Offset(1, 1));
    await tester.tap(find.text('Finish Introspection'));

    // verify values were saved
    verify(presenter.saveChanges(any, any, any, any, any, any, any, any)).called(1);
  });

  testWidgets('DailyIntrospectionForm test validator successful', (tester) async {
    final presenter = MockDailyIntrospectionPresenter();

    final report = HappinessReportModel.empty();

    final form =
    DailyIntrospectionForm(presenter: presenter, constraints: const BoxConstraints(maxHeight: 1200, maxWidth: 1200), report: report, date: DateFormat('yyyy-MM-dd').format(DateTime.now()),);

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
    await tester.tap(find.byType(RatingBar).at(1));
    await tester.tap(find.byType(RatingBar).at(2));
    await tester.tap(find.byType(RatingBar).last);
    await tester.enterText(find.widgetWithIcon(AnswerTextField, FontAwesomeIcons.heart), 'Accomplishments');
    await tester.enterText(find.widgetWithIcon(AnswerTextField, FontAwesomeIcons.handshake), 'Contributions');
    await tester.enterText(find.widgetWithIcon(AnswerTextField, FontAwesomeIcons.lightbulb), 'My new Insight');

    // submit form
    await tester.dragUntilVisible(find.text('Finish Introspection'), find.byType(SingleChildScrollView), const Offset(1, 1));
    await tester.tap(find.text('Finish Introspection'));

    // verify values were saved
    verify(presenter.saveChanges(any, any, any, any, any, any, any, any)).called(1);
  });

  testWidgets('DailyIntrospectionForm test text capitalization', (tester) async {
    final presenter = MockDailyIntrospectionPresenter();

    final report = HappinessReportModel.empty();

    final form =
    DailyIntrospectionForm(presenter: presenter, constraints: const BoxConstraints(maxHeight: 1200, maxWidth: 1200), report: report, date: DateFormat('yyyy-MM-dd').format(DateTime.now()),);

    await tester.pumpWidget(LocalizationsInj(
      locale: const Locale('en'),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: form,),
        ),),),);

    await tester.pumpAndSettle();

    // enter form values
    await tester.enterText(find.widgetWithIcon(AnswerTextField, FontAwesomeIcons.heart), 'those are my accomplishments. i think they are great.');
    await tester.enterText(find.widgetWithIcon(AnswerTextField, FontAwesomeIcons.handshake), 'those are my contributions. i think they are great.');
    await tester.enterText(find.widgetWithIcon(AnswerTextField, FontAwesomeIcons.lightbulb), 'those are my insights. i think they are great.');

    // check if they are capitalized
    expect(find.text('Those are my accomplishments. I think they are great.'), findsOneWidget);
    expect(find.text('Those are my contributions. I think they are great.'), findsOneWidget);
    expect(find.text('Those are my insights. I think they are great.'), findsOneWidget);
  });
}
