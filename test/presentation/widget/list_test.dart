import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/presentation/ui/widgets/introspection_history/introspection_list_date_range_header.dart';
import 'package:intl/intl.dart';

import '../../localizations_injection.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('DateRangePickerHeader displays correct date range',
      (WidgetTester tester) async {
    DateTimeRange? selectedDateRange;

    final widget = ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        home: LocalizationsInj(
          locale: const Locale('en'),
          child: Material(
            child: SingleChildScrollView(
              child: SizedBox(
                width: 400,
                height: 400,
                child: DateRangePickerHeader(
                  onDateRangeSelected: (range) {
                    selectedDateRange = range;
                  },
                  constraints: const BoxConstraints(),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);

    // Verify the initial state (Anytime)
    expect(find.text('Anytime'), findsOneWidget);

    final dropdownButtonFinder = find.byType(DropdownButton<RangeSelection>);
    var thisWeekFinder = find.byWidgetPredicate(
      (Widget widget) =>
          widget is DropdownMenuItem<RangeSelection> &&
          widget.value == RangeSelection.thisWeek,
    );

    // Tap on the dropdown button and open the options
    await tester.tap(dropdownButtonFinder);
    await tester.pumpAndSettle();

    // Select the "This Week" option
    await tester.ensureVisible(thisWeekFinder.last);
    await tester.tap(thisWeekFinder.last);
    await tester.pumpAndSettle();

    thisWeekFinder = find.byWidgetPredicate(
      (Widget widget) =>
          widget is DropdownMenuItem<RangeSelection> &&
          widget.value == RangeSelection.lastWeek,
    );

    // Tap on the dropdown button and open the options
    await tester.tap(dropdownButtonFinder);
    await tester.pumpAndSettle();

    // Select the "This Week" option
    await tester.ensureVisible(thisWeekFinder.last);
    await tester.tap(thisWeekFinder.last);
    await tester.pumpAndSettle();

    thisWeekFinder = find.byWidgetPredicate(
      (Widget widget) =>
          widget is DropdownMenuItem<RangeSelection> &&
          widget.value == RangeSelection.thisMonth,
    );

    // Tap on the dropdown button and open the options
    await tester.tap(dropdownButtonFinder);
    await tester.pumpAndSettle();

    // Select the "This Week" option
    await tester.ensureVisible(thisWeekFinder.last);
    await tester.tap(thisWeekFinder.last);
    await tester.pumpAndSettle();

    thisWeekFinder = find.byWidgetPredicate(
      (Widget widget) =>
          widget is DropdownMenuItem<RangeSelection> &&
          widget.value == RangeSelection.lastMonth,
    );

    // Tap on the dropdown button and open the options
    await tester.tap(dropdownButtonFinder);
    await tester.pumpAndSettle();

    // Select the "This Week" option
    await tester.ensureVisible(thisWeekFinder.last);
    await tester.tap(thisWeekFinder.last);
    await tester.pumpAndSettle();

    thisWeekFinder = find.byWidgetPredicate(
      (Widget widget) =>
          widget is DropdownMenuItem<RangeSelection> &&
          widget.value == RangeSelection.anytime,
    );

    // Tap on the dropdown button and open the options
    await tester.tap(dropdownButtonFinder);
    await tester.pumpAndSettle();

    // Select the "This Week" option
    await tester.ensureVisible(thisWeekFinder.last);
    await tester.tap(thisWeekFinder.last);
    await tester.pumpAndSettle();

    thisWeekFinder = find.byWidgetPredicate(
      (Widget widget) =>
          widget is DropdownMenuItem<RangeSelection> &&
          widget.value == RangeSelection.thisWeek,
    );

    // Tap on the dropdown button and open the options
    await tester.tap(dropdownButtonFinder);
    await tester.pumpAndSettle();

    // Select the "This Week" option
    await tester.ensureVisible(thisWeekFinder.last);
    await tester.tap(thisWeekFinder.last);
    await tester.pumpAndSettle();

    // Verify the date range is displayed correctly
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    final dateFormat = DateFormat('MMM d, y');
    final startDate = dateFormat.format(startOfWeek);
    final endDate = dateFormat.format(endOfWeek);
    final formattedDateRange = '$startDate - $endDate';

    expect(find.text(formattedDateRange), findsOneWidget);

    // Verify the date range passed to the callback
    expect(selectedDateRange, isNotNull);
    expect(selectedDateRange!.start.day, startOfWeek.day);
    expect(selectedDateRange!.end.day, endOfWeek.day);
  });

  testWidgets('DateRangePickerHeader can clear the date range',
      (WidgetTester tester) async {
    DateTimeRange? selectedDateRange;
    final widget = ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        home: LocalizationsInj(
          locale: const Locale('en'),
          child: Material(
            child: SingleChildScrollView(
              child: SizedBox(
                width: 400,
                height: 400,
                child: DateRangePickerHeader(
                  onDateRangeSelected: (range) {
                    selectedDateRange = range;
                  },
                  constraints: const BoxConstraints(),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);

    // Tap on the dropdown button and open the options
    final dropdownButtonFinder = find.byType(DropdownButton<RangeSelection>);
    final thisWeekFinder = find.byWidgetPredicate(
      (Widget widget) =>
          widget is DropdownMenuItem<RangeSelection> &&
          widget.value == RangeSelection.thisWeek,
    );

    await tester.tap(dropdownButtonFinder);
    await tester.pumpAndSettle();

    // Select the "This Week" option
    await tester.ensureVisible(thisWeekFinder.last);
    await tester.tap(thisWeekFinder.last);
    await tester.pumpAndSettle();

    // Tap on the clear button
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pumpAndSettle();

    // Verify the date range is cleared
    expect(find.text('Anytime'), findsOneWidget);

    // Verify the date range passed to the callback is null
    expect(selectedDateRange, isNull);
  });

  testWidgets('DateRangePickerHeader opens custom date range picker and selects a range', (WidgetTester tester) async {
    DateTimeRange? selectedDateRange;

    final widget = ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        home: LocalizationsInj(
          locale: const Locale('en'),
          child: Material(
            child: SingleChildScrollView(
              child: SizedBox(
                width: 400, height: 400,
                child: DateRangePickerHeader(
                  onDateRangeSelected: (range) {
                    selectedDateRange = range;
                  },
                  constraints: const BoxConstraints(),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);

    // Find the date range picker IconButton using the key
    final dateRangePickerIconButton = find.byIcon(Icons.date_range);

    // Tap on the IconButton to open the date range picker
    await tester.tap(dateRangePickerIconButton);
    await tester.pumpAndSettle();

    // Calculate the dates to select
    final now = DateTime.now();
    final startDate = now;
    final endDate = now;

    // Select dates
    await tester.tap(find.text(startDate.day.toString()).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text(endDate.day.toString()).last);
    await tester.pumpAndSettle();

    // Tap on SAVE button
    await tester.tap(find.text('SAVE'));
    await tester.pumpAndSettle();

    // Verify the custom date range passed to the callback
    expect(selectedDateRange, isNotNull);
    expect(selectedDateRange!.start.year, startDate.year);
    expect(selectedDateRange!.start.month, startDate.month);
    expect(selectedDateRange!.start.day, startDate.day);
    expect(selectedDateRange!.end.year, endDate.year);
    expect(selectedDateRange!.end.month, endDate.month);
    expect(selectedDateRange!.end.day, endDate.day);
  });
}
