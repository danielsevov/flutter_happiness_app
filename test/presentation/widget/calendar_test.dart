import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/base_report_body.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/daily_intro_report_body_narrow.dart';
import 'package:happiness_app/presentation/ui/widgets/introspection_history/introspection_calendar_builders.dart';
import 'package:happiness_app/presentation/ui/widgets/introspection_history/introspection_calendar_empty_date_mark.dart';
import 'package:happiness_app/presentation/ui/widgets/introspection_history/introspection_calendar_report_date_mark.dart';

void main() {
  group('CustomCalendarBuilders', () {
    BoxConstraints constraints;
    Map<DateTime, BaseReportBody> widgets;

    testWidgets('todayBuilder: Green cells for dates with reports',
        (WidgetTester tester) async {
      // Arrange
      final reportDate = DateTime(2023, 5);
      constraints = const BoxConstraints.tightFor(width: 48, height: 48);
      widgets = {
        DateTime(2023, 5): DailyIntrospectionReportBodyNarrow(
          report: HappinessReportModel.empty(date: '01-05-2023'),
          constraints: constraints,
        ),
        DateTime(2023, 5, 10): DailyIntrospectionReportBodyNarrow(
          report: HappinessReportModel.empty(date: '10-05-2023'),
          constraints: constraints,
        ),
      };
      final calendarBuilders =
          CustomCalendarBuilders.getCalendarBuilders(constraints, widgets);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              final widget = calendarBuilders.todayBuilder!(
                context,
                reportDate,
                DateTime.now(),
              );
              return Material(child: widget);
            },
          ),
        ),
      );

      // Assert
      expect(find.byType(CalendarReportDateMark), findsOneWidget);
    });

    testWidgets('todayBuilder: Empty date mark for dates without reports',
        (WidgetTester tester) async {
      // Arrange
      final reportDate = DateTime.now();
      constraints = const BoxConstraints.tightFor(width: 48, height: 48);
      widgets = {};
      final calendarBuilders =
          CustomCalendarBuilders.getCalendarBuilders(constraints, widgets);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              final widget = calendarBuilders.todayBuilder!(
                context,
                reportDate,
                DateTime.now(),
              );
              return Material(child: widget);
            },
          ),
        ),
      );

      // Assert
      expect(find.byType(CalendarEmptyDateMark), findsOneWidget);
    });

    testWidgets('outsideBuilder: Green cells for dates with reports',
        (WidgetTester tester) async {
      // Arrange
          final reportDate = DateTime(2023, 5, 2);
          constraints = const BoxConstraints.tightFor(width: 48, height: 48);
          widgets = {
            DateTime(2023, 5, 2): DailyIntrospectionReportBodyNarrow(
              report: HappinessReportModel.empty(date: '02-05-2023'),
              constraints: constraints,
            ),
            DateTime(2023, 5, 10): DailyIntrospectionReportBodyNarrow(
              report: HappinessReportModel.empty(date: '10-05-2023'),
              constraints: constraints,
            ),
          };
      final calendarBuilders =
          CustomCalendarBuilders.getCalendarBuilders(constraints, widgets);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              final widget = calendarBuilders.outsideBuilder!(
                context,
                reportDate,
                DateTime.now(),
              );
              return Material(child: widget);
            },
          ),
        ),
      );

      // Assert
      expect(find.byType(CalendarReportDateMark), findsOneWidget);
    });

    testWidgets('outsideBuilder: Empty date mark for dates without reports',
        (WidgetTester tester) async {
      // Arrange
      final reportDate = DateTime.now();
      constraints = const BoxConstraints.tightFor(width: 48, height: 48);
      widgets = {};
      final calendarBuilders =
          CustomCalendarBuilders.getCalendarBuilders(constraints, widgets);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              final widget = calendarBuilders.outsideBuilder!(
                context,
                reportDate,
                DateTime.now(),
              );
              return Material(child: widget);
            },
          ),
        ),
      );

      // Assert
      expect(find.byType(CalendarEmptyDateMark), findsOneWidget);
    });

    testWidgets('defaultBuilder: Green cells for dates with reports',
        (WidgetTester tester) async {
      // Arrange
          final reportDate = DateTime(2023, 5, 2);
          constraints = const BoxConstraints.tightFor(width: 48, height: 48);
          widgets = {
            DateTime(2023, 5, 2): DailyIntrospectionReportBodyNarrow(
              report: HappinessReportModel.empty(date: '02-05-2023'),
              constraints: constraints,
            ),
            DateTime(2023, 5, 10): DailyIntrospectionReportBodyNarrow(
              report: HappinessReportModel.empty(date: '10-05-2023'),
              constraints: constraints,
            ),
          };
      final calendarBuilders =
          CustomCalendarBuilders.getCalendarBuilders(constraints, widgets);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              final widget = calendarBuilders.defaultBuilder!(
                context,
                reportDate,
                DateTime.now(),
              );
              return Material(child: widget);
            },
          ),
        ),
      );

      // Assert
      expect(find.byType(CalendarReportDateMark), findsOneWidget);
    });

    testWidgets('defaultBuilder: Empty date mark for dates without reports',
        (WidgetTester tester) async {
      // Arrange
      final reportDate = DateTime.now();
      constraints = const BoxConstraints.tightFor(width: 48, height: 48);
      widgets = {};
      final calendarBuilders =
          CustomCalendarBuilders.getCalendarBuilders(constraints, widgets);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              final widget = calendarBuilders.defaultBuilder!(
                context,
                reportDate,
                DateTime.now(),
              );
              return Material(child: widget);
            },
          ),
        ),
      );

      // Assert
      expect(find.byType(CalendarEmptyDateMark), findsOneWidget);
    });

    testWidgets('outsideBuilder: Green cells for dates with reports',
        (WidgetTester tester) async {
      // Arrange
          final reportDate = DateTime(2023, 5, 2);
          constraints = const BoxConstraints.tightFor(width: 48, height: 48);
          widgets = {
            DateTime(2023, 5, 2): DailyIntrospectionReportBodyNarrow(
              report: HappinessReportModel.empty(date: '02-05-2023'),
              constraints: constraints,
            ),
            DateTime(2023, 5, 10): DailyIntrospectionReportBodyNarrow(
              report: HappinessReportModel.empty(date: '10-05-2023'),
              constraints: constraints,
            ),
          };
      final calendarBuilders =
          CustomCalendarBuilders.getCalendarBuilders(constraints, widgets);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              final widget = calendarBuilders.outsideBuilder!(
                context,
                reportDate,
                DateTime.now(),
              );
              return Material(child: widget);
            },
          ),
        ),
      );

      // Assert
      expect(find.byType(CalendarReportDateMark), findsOneWidget);
    });

    testWidgets('defaultBuilder: Green cells for dates with reports',
        (WidgetTester tester) async {
      // Arrange
          final reportDate = DateTime(2023, 5, 2);
          constraints = const BoxConstraints.tightFor(width: 48, height: 48);
          widgets = {
            DateTime(2023, 5, 2): DailyIntrospectionReportBodyNarrow(
              report: HappinessReportModel.empty(date: '02-05-2023'),
              constraints: constraints,
            ),
            DateTime(2023, 5, 10): DailyIntrospectionReportBodyNarrow(
              report: HappinessReportModel.empty(date: '10-05-2023'),
              constraints: constraints,
            ),
          };
      final calendarBuilders =
          CustomCalendarBuilders.getCalendarBuilders(constraints, widgets);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              final widget = calendarBuilders.defaultBuilder!(
                context,
                reportDate,
                DateTime.now(),
              );
              return Material(child: widget);
            },
          ),
        ),
      );

      // Assert
      expect(find.byType(CalendarReportDateMark), findsOneWidget);
    });
  });

  group('CalendarReportDateMark', () {
    BoxConstraints constraints;
    Map<DateTime, BaseReportBody> widgets;
    late DateTime date;
    late DateTime day;

    testWidgets('renders CalendarReportDateMark correctly',
        (WidgetTester tester) async {
      constraints = const BoxConstraints.tightFor(width: 48, height: 48);
      date = DateTime(2023, 5);
      day = DateTime(2023, 5);
      widgets = {
        DateTime(2023, 5): DailyIntrospectionReportBodyNarrow(
          report: HappinessReportModel.empty(date: '01-05-2023'),
          constraints: constraints,
        ),
      };

      // Arrange
      const backgroundColor = Colors.green;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: CalendarReportDateMark(
              constraints: constraints,
              d: date,
              day: day,
              widgets: widgets,
              backgroundColor: backgroundColor,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CalendarReportDateMark), findsOneWidget);
      expect(find.text('${day.day}'), findsOneWidget);
    });

    testWidgets('shows SimpleDialog on double tap',
        (WidgetTester tester) async {
      constraints = const BoxConstraints.tightFor(width: 48, height: 48);
      date = DateTime(2023, 5);
      day = DateTime(2023, 5);
      widgets = {
        DateTime(2023, 5): TestReport(
          report: HappinessReportModel.empty(),
          constraints: constraints,
        ),
      };

      // Arrange
      const backgroundColor = Colors.green;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: CalendarReportDateMark(
              constraints: constraints,
              d: date,
              day: day,
              widgets: widgets,
              backgroundColor: backgroundColor,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CalendarReportDateMark));
      await tester.pump(kDoubleTapMinTime);
      await tester.tap(find.byType(CalendarReportDateMark));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('success'), findsOneWidget);
    });
  });
}

class TestReport extends BaseReportBody {
  const TestReport(
      {required super.report, required super.constraints, super.key,});

  @override
  Widget build(BuildContext context) {
    return const Text('success');
  }
}
