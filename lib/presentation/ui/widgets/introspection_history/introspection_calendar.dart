import 'package:flutter/material.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/base_report_body.dart';
import 'package:happiness_app/presentation/ui/widgets/introspection_history/introspection_calendar_builders.dart';
import 'package:table_calendar/table_calendar.dart';

/// Custom calendar widget for overviewing daily introspection entries.
/// Placed on the introspection history page view.
class IntrospectionCalendar extends StatelessWidget {
  const IntrospectionCalendar({
    required this.widgets,
    required this.constraints,
    super.key,
  });

  final Map<DateTime, BaseReportBody> widgets;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
        ),
      ),
      child: TableCalendar(
        rowHeight: 40,
        availableGestures: AvailableGestures.horizontalSwipe,
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarStyle: CalendarStyle(
          weekendTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: Helper.getSmallTextSize(constraints),
          ),
          todayDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
          todayTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: Helper.getSmallTextSize(constraints),
          ),
          disabledTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
            fontSize: Helper.getSmallTextSize(constraints),
          ),
          outsideTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: Helper.getSmallTextSize(constraints),
          ),
          defaultTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: Helper.getSmallTextSize(constraints),
          ),
        ),
        headerStyle: HeaderStyle(
          titleTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: Helper.getNormalTextSize(constraints),
          ),
          formatButtonTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: Helper.getNormalTextSize(constraints),
          ),
          leftChevronIcon: Icon(
            Icons.arrow_circle_left,
            color: Theme.of(context).colorScheme.primary,
            size: Helper.getIconSize(constraints),
          ),
          rightChevronIcon: Icon(
            Icons.arrow_circle_right,
            color: Theme.of(context).colorScheme.primary,
            size: Helper.getIconSize(constraints),
          ),
          titleCentered: true,
          formatButtonVisible: false,
        ),
        daysOfWeekHeight: 50,
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: Helper.getNormalTextSize(constraints),
          ),
          weekendStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: Helper.getNormalTextSize(constraints),
          ),
        ),

        //manage style of selected cells
        calendarBuilders:
            CustomCalendarBuilders.getCalendarBuilders(constraints, widgets),
        focusedDay: DateTime.now(),
        firstDay: DateTime.utc(2000),
        lastDay: DateTime.now(),
      ),
    );
  }
}
