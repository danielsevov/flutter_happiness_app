// ignore_for_file: lines_longer_than_80_chars, cascade_invocations

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/presentation/presenters/daily_intro_presenter.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/happiness_report.dart';
import 'package:mockito/annotations.dart';

import '../../localizations_injection.dart';

@GenerateMocks([DailyIntrospectionPresenter])
void main() {
  group('narrow body tests', () {
    testWidgets('DailyIntrospectionReport test constructor', (tester) async {
      final report = HappinessReportModel.newDailyReport(
          happinessLevel: 1,
          sadnessLevel: 2,
          angerLevel: 3,
          fearLevel: 4,
          careForSelf: 'Care self',
          careForOthers: 'Care others',
          insight: 'My insight',
          date: 'Date 1',
          employeeId: 0,);
      report.setNewId(1);

      final widget = HappinessReport(report: report, rank: 1,);

      await tester.pumpWidget(MaterialApp(
          title: 'Flutter Demo',
          home: Scaffold(
              body: Center(
                child: SingleChildScrollView(child: widget),
              ),),),);

      await tester.pumpAndSettle();

      expect(find.textContaining('Date 1'), findsOneWidget);
      expect(find.textContaining('#1'), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    });

    testWidgets('DailyIntrospectionReport expand test', (tester) async {
      final report = HappinessReportModel.newDailyReport(
        happinessLevel: 1,
        sadnessLevel: 2,
        angerLevel: 3,
        fearLevel: 4,
        careForSelf: 'Care self',
        careForOthers: 'Care others',
        insight: 'My insight',
        date: 'Date 1',
        employeeId: 0,);
      report.setNewId(1);

      final widget = HappinessReport(report: report, rank: 1,);

      await tester.pumpWidget(LocalizationsInj(
          locale: const Locale('en'),
          child: Scaffold(
              body: Center(
                child: SingleChildScrollView(
                    child: SizedBox(width: 400, height: 400, child: widget),),
              ),),),);

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));

      await tester.dragUntilVisible(find.byIcon(FontAwesomeIcons.faceSadTear),
          find.byType(SingleChildScrollView), const Offset(1, 1),);
      expect(find.byIcon(FontAwesomeIcons.faceAngry), findsOneWidget);
      expect(find.byIcon(FontAwesomeIcons.faceGrimace), findsOneWidget);
      expect(find.byIcon(FontAwesomeIcons.faceLaughBeam), findsOneWidget);
      expect(find.byIcon(FontAwesomeIcons.faceSadTear), findsOneWidget);

      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);

      expect(find.text('What did I do for myself:'), findsOneWidget);
      expect(find.text('What did I do for others:'), findsOneWidget);
      expect(find.text('What is my insight for today:'), findsOneWidget);

      expect(find.text('Care self'), findsOneWidget);
      expect(find.text('Care others'), findsOneWidget);
      expect(find.text('My insight'), findsOneWidget);

      await tester.dragUntilVisible(find.byIcon(Icons.keyboard_arrow_up),
          find.byType(SingleChildScrollView), const Offset(1, 1),);
      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
    });

    testWidgets('DailyIntrospectionReport expand test', (tester) async {
      final report = HappinessReportModel.newDailyReport(
        happinessLevel: 1,
        sadnessLevel: 2,
        angerLevel: 3,
        fearLevel: 4,
        careForSelf: 'Care self',
        careForOthers: 'Care others',
        insight: 'My insight',
        date: 'Date 1',
        employeeId: 0,);
      report.setNewId(1);

      final widget = HappinessReport(report: report, rank: 1,);

      await tester.pumpWidget(LocalizationsInj(
        locale: const Locale('en'),
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: SizedBox(width: 400, height: 400, child: widget),),
          ),),),);

      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('Date 1'));
      await tester.pump(kDoubleTapMinTime);
      await tester.tap(find.textContaining('Date 1'));

      await tester.dragUntilVisible(find.byIcon(FontAwesomeIcons.faceSadTear),
        find.byType(SingleChildScrollView), const Offset(1, 1),);
      expect(find.byIcon(FontAwesomeIcons.faceAngry), findsOneWidget);
      expect(find.byIcon(FontAwesomeIcons.faceGrimace), findsOneWidget);
      expect(find.byIcon(FontAwesomeIcons.faceLaughBeam), findsOneWidget);
      expect(find.byIcon(FontAwesomeIcons.faceSadTear), findsOneWidget);

      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);

      expect(find.text('What did I do for myself:'), findsOneWidget);
      expect(find.text('What did I do for others:'), findsOneWidget);
      expect(find.text('What is my insight for today:'), findsOneWidget);

      expect(find.text('Care self'), findsOneWidget);
      expect(find.text('Care others'), findsOneWidget);
      expect(find.text('My insight'), findsOneWidget);

      await tester.dragUntilVisible(find.byIcon(Icons.keyboard_arrow_up),
        find.byType(SingleChildScrollView), const Offset(1, 1),);
      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
    });
  });

  group('wide body tests', () {
    testWidgets('DailyIntrospectionReport test constructor', (tester) async {
      final report = HappinessReportModel.newDailyReport(
        happinessLevel: 1,
        sadnessLevel: 2,
        angerLevel: 3,
        fearLevel: 4,
        careForSelf: 'Care self',
        careForOthers: 'Care others',
        insight: 'My insight',
        date: 'Date 1',
        employeeId: 0,);
      report.setNewId(1);

      final widget = HappinessReport(report: report, rank: 1,);

      await tester.pumpWidget(MaterialApp(
          title: 'Flutter Demo',
          home: Scaffold(
              body: Center(
                child: SizedBox(width: 1200, height: 600, child: SingleChildScrollView(child: widget)),
              ),),),);

      await tester.pumpAndSettle();

      expect(find.textContaining('Date 1'), findsOneWidget);
      expect(find.textContaining('#1'), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    });

    testWidgets('DailyIntrospectionReport expand test', (tester) async {
      final report = HappinessReportModel.newDailyReport(
        happinessLevel: 1,
        sadnessLevel: 2,
        angerLevel: 3,
        fearLevel: 4,
        careForSelf: 'Care self',
        careForOthers: 'Care others',
        insight: 'My insight',
        date: 'Date 1',
        employeeId: 0,);
      report.setNewId(1);

      final widget = HappinessReport(report: report, rank: 1,);

      await tester.pumpWidget(LocalizationsInj(
          locale: const Locale('en'),
          child: Scaffold(
              body: Center(
                child: SingleChildScrollView(
                    child: SizedBox(width: 1200, height: 600, child: widget),),
              ),),),);

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));

      await tester.dragUntilVisible(find.byIcon(FontAwesomeIcons.faceSadTear),
          find.byType(SingleChildScrollView), const Offset(1, 1),);
      expect(find.byIcon(FontAwesomeIcons.faceAngry), findsOneWidget);
      expect(find.byIcon(FontAwesomeIcons.faceGrimace), findsOneWidget);
      expect(find.byIcon(FontAwesomeIcons.faceLaughBeam), findsOneWidget);
      expect(find.byIcon(FontAwesomeIcons.faceSadTear), findsOneWidget);

      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);

      expect(find.text('What did I do for myself:'), findsOneWidget);
      expect(find.text('What did I do for others:'), findsOneWidget);
      expect(find.text('What is my insight for today:'), findsOneWidget);

      expect(find.text('Care self'), findsOneWidget);
      expect(find.text('Care others'), findsOneWidget);
      expect(find.text('My insight'), findsOneWidget);

      await tester.dragUntilVisible(find.byIcon(Icons.keyboard_arrow_up),
          find.byType(SingleChildScrollView), const Offset(1, 1),);
      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
    });

    testWidgets('DailyIntrospectionReport expand test', (tester) async {
      final report = HappinessReportModel.newDailyReport(
        happinessLevel: 1,
        sadnessLevel: 2,
        angerLevel: 3,
        fearLevel: 4,
        careForSelf: 'Care self',
        careForOthers: 'Care others',
        insight: 'My insight',
        date: 'Date 1',
        employeeId: 0,);
      report.setNewId(1);

      final widget = HappinessReport(report: report, rank: 1,);

      await tester.pumpWidget(LocalizationsInj(
        locale: const Locale('en'),
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: SizedBox(width: 1200, height: 600, child: widget),),
          ),),),);

      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('Date 1'));
      await tester.pump(kDoubleTapMinTime);
      await tester.tap(find.textContaining('Date 1'));

      await tester.dragUntilVisible(find.byIcon(FontAwesomeIcons.faceSadTear),
        find.byType(SingleChildScrollView), const Offset(1, 1),);
      expect(find.byIcon(FontAwesomeIcons.faceAngry), findsOneWidget);
      expect(find.byIcon(FontAwesomeIcons.faceGrimace), findsOneWidget);
      expect(find.byIcon(FontAwesomeIcons.faceLaughBeam), findsOneWidget);
      expect(find.byIcon(FontAwesomeIcons.faceSadTear), findsOneWidget);

      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);

      expect(find.text('What did I do for myself:'), findsOneWidget);
      expect(find.text('What did I do for others:'), findsOneWidget);
      expect(find.text('What is my insight for today:'), findsOneWidget);

      expect(find.text('Care self'), findsOneWidget);
      expect(find.text('Care others'), findsOneWidget);
      expect(find.text('My insight'), findsOneWidget);

      await tester.dragUntilVisible(find.byIcon(Icons.keyboard_arrow_up),
        find.byType(SingleChildScrollView), const Offset(1, 1),);
      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
    });
  });

  group('weekly report tests', () {
    testWidgets('Weekly Report test constructor', (tester) async {
      final report = HappinessReportModel.newWeeklyReport(
        happinessLevel: 1,
        careForSelf: 'Care self',
        insight: 'My insight',
        date: '20-04-2023',
        employeeId: 0,);
      report.setNewId(1);

      final widget = HappinessReport(report: report, rank: 1,);

      await tester.pumpWidget(LocalizationsInj(
        locale: const Locale('en'),
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: SizedBox(width: 1200, height: 600, child: widget),),
          ),),),);

      await tester.pumpAndSettle();

      expect(find.textContaining('Week 16, 2023'), findsOneWidget);
      expect(find.textContaining('#1'), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    });

    testWidgets('Weekly Report expand test', (tester) async {
      final report = HappinessReportModel.newWeeklyReport(
        happinessLevel: 1,
        careForSelf: 'Care self',
        insight: 'My insight',
        date: '01-01-2000',
        employeeId: 0,);
      report.setNewId(1);

      final widget = HappinessReport(report: report, rank: 1,);

      await tester.pumpWidget(LocalizationsInj(
        locale: const Locale('en'),
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: SizedBox(width: 1200, height: 600, child: widget),),
          ),),),);

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));

      await tester.dragUntilVisible(find.byIcon(FontAwesomeIcons.star),
        find.byType(SingleChildScrollView), const Offset(1, 1),);
      expect(find.byIcon(FontAwesomeIcons.star), findsOneWidget);

      expect(find.text('1'), findsOneWidget);

      expect(find.text('Weekly rating:'), findsOneWidget);
      expect(find.text('Why did I choose this rating:'), findsOneWidget);
      expect(find.text('What did I learn:'), findsOneWidget);

      expect(find.text('Care self'), findsOneWidget);
      expect(find.text('My insight'), findsOneWidget);

      await tester.dragUntilVisible(find.byIcon(Icons.keyboard_arrow_up),
        find.byType(SingleChildScrollView), const Offset(1, 1),);
      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
    });

    testWidgets('Weekly Report expand test', (tester) async {
      final report = HappinessReportModel.newWeeklyReport(
        happinessLevel: 1,
        careForSelf: 'Care self',
        insight: 'My insight',
        date: '20-04-2023',
        employeeId: 0,);
      report.setNewId(1);

      final widget = HappinessReport(report: report, rank: 1,);

      await tester.pumpWidget(LocalizationsInj(
        locale: const Locale('en'),
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: SizedBox(width: 1200, height: 600, child: widget),),
          ),),),);

      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('Week 16, 2023'));
      await tester.pump(kDoubleTapMinTime);
      await tester.tap(find.textContaining('Week 16, 2023'));

      await tester.dragUntilVisible(find.byIcon(FontAwesomeIcons.star),
        find.byType(SingleChildScrollView), const Offset(1, 1),);
      expect(find.byIcon(FontAwesomeIcons.star), findsOneWidget);

      expect(find.text('1'), findsOneWidget);

      expect(find.text('Weekly rating:'), findsOneWidget);
      expect(find.text('Why did I choose this rating:'), findsOneWidget);
      expect(find.text('What did I learn:'), findsOneWidget);

      expect(find.text('Care self'), findsOneWidget);
      expect(find.text('My insight'), findsOneWidget);

      await tester.dragUntilVisible(find.byIcon(Icons.keyboard_arrow_up),
        find.byType(SingleChildScrollView), const Offset(1, 1),);
      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
    });
  });
}
