import 'package:flutter/material.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/base_report_body.dart';
import 'package:happiness_app/presentation/ui/widgets/introspection_history/introspection_calendar_empty_date_mark.dart';
import 'package:happiness_app/presentation/ui/widgets/introspection_history/introspection_calendar_report_date_mark.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendarBuilders {
  CustomCalendarBuilders(this.constraints, this.widgets);

  final BoxConstraints constraints;
  final Map<DateTime, BaseReportBody> widgets;

  static CalendarBuilders<dynamic> getCalendarBuilders(
    BoxConstraints constraints,
    Map<DateTime, BaseReportBody> widgets,
  ) {
    return CalendarBuilders(
      todayBuilder: (context, day, focusedDay) {
        final dates = widgets.keys;

        //green cells
        for (final d in dates) {
          if (day.day == d.day && day.month == d.month && day.year == d.year) {
            return CalendarReportDateMark(
                constraints: constraints, d: d, day: day, widgets: widgets,
              backgroundColor: Theme.of(context).colorScheme.onBackground,);
          }
        }
        return CalendarEmptyDateMark(day: day, constraints: constraints,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          textColor: Theme.of(context).colorScheme.background,);
      },
      outsideBuilder: (context, day, focusedDay) {
        final dates = widgets.keys;

        //green cells
        for (final d in dates) {
          if (day.day == d.day && day.month == d.month && day.year == d.year) {
            return CalendarReportDateMark(
                constraints: constraints, d: d, day: day, widgets: widgets,
              backgroundColor: Theme.of(context).colorScheme.background,);
          }
        }
        return CalendarEmptyDateMark(day: day, constraints: constraints,
          backgroundColor: Theme.of(context).colorScheme.background,
          textColor: Theme.of(context).colorScheme.primary,);
      },
      defaultBuilder: (context, day, focusedDay) {
        final dates = widgets.keys;

        //green cells
        for (final d in dates) {
          if (day.day == d.day && day.month == d.month && day.year == d.year) {
            return CalendarReportDateMark(
              constraints: constraints, d: d, day: day, widgets: widgets,
              backgroundColor: Theme.of(context).colorScheme.background,);
          }
        }
        return CalendarEmptyDateMark(day: day, constraints: constraints,
          backgroundColor: Theme.of(context).colorScheme.background,
          textColor: Theme.of(context).colorScheme.onBackground,);
      },
    );
  }
}
