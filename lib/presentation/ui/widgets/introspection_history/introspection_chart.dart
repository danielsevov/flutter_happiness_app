
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:happiness_app/app_colors.dart';
import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/base_report_body.dart';
import 'package:happiness_app/presentation/ui/widgets/introspection_history/introspection_bar_chart.dart';
import 'package:happiness_app/presentation/ui/widgets/introspection_history/introspection_chart_period_dropdown.dart';
import 'package:happiness_app/presentation/ui/widgets/introspection_history/introspection_chart_period_type_dropdown.dart';
import 'package:happiness_app/presentation/ui/widgets/introspection_history/introspection_chart_type_dropdown.dart';
import 'package:happiness_app/presentation/ui/widgets/introspection_history/introspection_time_chart.dart';
import 'package:intl/intl.dart';

/// Custom chart widget for overviewing happiness report entries.
/// Placed on the introspection history page view.
class IntrospectionChart extends StatefulWidget {
  const IntrospectionChart({
    required this.widgets,
    required this.constraints,
    required this.onPressed,
    required this.isExpanded,
    required this.fetchDaily,
    required this.height,
    super.key,
  });

  final Map<DateTime, BaseReportBody> widgets;
  final BoxConstraints constraints;
  final void Function() onPressed;
  final bool isExpanded;
  final bool fetchDaily;
  final double height;

  @override
  State<IntrospectionChart> createState() => IntrospectionChartState();
}

class IntrospectionChartState extends State<IntrospectionChart> {
  int numberOfPeriodsToShow = 12;
  int currentPeriodIndex = 0;
  bool isBarChart = true;
  GroupBy groupedBy = GroupBy.week;

  late AppLocalizations localizations;

  Map<String, bool> _visibleFeeling = {
    'happiness': true,
    'sadness': true,
    'anger': true,
    'fear': true,
  };

  // Legend widget
  Widget _buildLegend() {
    return Wrap(
      alignment: WrapAlignment.center,
      children: _visibleFeeling.keys.map((feeling) {
        return Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Checkbox(
              value: _visibleFeeling[feeling],
              activeColor: getFeelingColor(feeling),
              onChanged: (bool? value) {
                setState(() {
                  _visibleFeeling[feeling] = value!;
                });
              },
            ),
            Text(
              feeling[0].toUpperCase() + feeling.substring(1),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: getFeelingColor(feeling),
                fontSize: Helper.getSmallTextSize(widget.constraints),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Color getFeelingColor(String feeling) {
    switch (feeling) {
      case 'happiness':
        return AppColors.happinessColor;
      case 'sadness':
        return AppColors.sadnessColor;
      case 'anger':
        return AppColors.angerColor;
      case 'fear':
        return AppColors.fearColor;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    localizations = AppLocalizations.of(context)!;

    final reports = <HappinessReportModel>[];

    // Add each report from the widgets map to the reports list
    widget.widgets.forEach((key, value) {
      reports.add(value.report);
    });

    // Group reports by period and calculate periodic averages
    final groupedReports = _groupReports(reports, currentPeriodIndex);
    final averages = _calculateAverages(groupedReports);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // dropdown menu for selection of periods
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.constraints.maxWidth > 1200)
              IconButton(
                onPressed: widget.onPressed,
                icon: Icon(
                  widget.isExpanded
                      ? Icons.close_fullscreen
                      : Icons.open_in_full,
                  color: Theme
                      .of(context)
                      .colorScheme
                      .onBackground,
                  size: Helper.getIconSize(widget.constraints),
                ),
              )
            else
              const SizedBox(),
            IntrospectionChartDropdownPeriodMenu(
              numberOfWeeksToShow: numberOfPeriodsToShow,
              onChanged: (int? newValue) {
                if (newValue != null) {
                  setState(() {
                    numberOfPeriodsToShow = newValue;
                  });
                }
              },
              constraints: widget.constraints,
            ),
          ],
        ),

        // the chart
        Container(
          height: widget.height,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
              Theme
                  .of(context)
                  .colorScheme
                  .onBackground
                  .withOpacity(0.5),
            ),
          ),
          child: Center(
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) {
                  // Swiped right
                  setState(() {
                    currentPeriodIndex += numberOfPeriodsToShow;
                  });
                } else if (details.primaryVelocity! < 0 &&
                    currentPeriodIndex > 0) {
                  // Swiped left
                  setState(() {
                    currentPeriodIndex -= numberOfPeriodsToShow;
                    if (currentPeriodIndex < 0) {
                      currentPeriodIndex = 0;
                    }
                  });
                }
              },
              child: isBarChart
                  ? IntrospectionBarChart(
                groupBy: groupedBy,
                averages: averages,
                constraints: widget.constraints,
                smallLabel: numberOfPeriodsToShow > 24,
              )
                  : IntrospectionTimeChart(
                averages: averages,
                numberOfPeriods: numberOfPeriodsToShow-1,
                constraints: widget.constraints,
                smallLabel: numberOfPeriodsToShow > 24,
                groupBy: groupedBy,
              ),
            ),
          ),
        ),

        widget.fetchDaily ? _buildLegend() : SizedBox(),

        // dropdown menu for bar / line chart choice
        SizedBox(
          width: widget.constraints.maxWidth,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: [
              IntrospectionChartDropdownPeriodTypeMenu(
                groupedBy: groupedBy,
                onChanged: (GroupBy? newValue) {
                  if (newValue != null) {
                    setState(() {
                      setGroupingBy(newValue);
                    });
                  }
                },
                constraints: widget.constraints,
              ),
              IntrospectionChartDropdownTypeMenu(
                isBarChart: isBarChart,
                onChanged: (bool? newValue) {
                  if (newValue != null) {
                    setState(() {
                      isBarChart = newValue;
                    });
                  }
                },
                constraints: widget.constraints,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void setGroupingBy(GroupBy newValue) {
    setState(() {
      groupedBy = newValue;
    });
  }

  /// Group reports by period
  Map<String, List<HappinessReportModel>> _groupReports(
      List<HappinessReportModel> reports,
      int index,) {
    final groupedReports = <String, List<HappinessReportModel>>{};
    final now = DateTime.now();

    final unitsAgo = _calculateUnitsAgo(now, index);

    // Initialize the map with empty lists for each unit
    _initializeGroupedReports(groupedReports, unitsAgo, reports);

    // Iterate through the reports and group them by unit
    for (final report in reports) {
      final reportDate = Helper.formatter.parse(report.date);

      // Ignore reports from before the units ago time
      if (reportDate.isBefore(unitsAgo)) {
        continue;
      }

      final unitStart = _findUnitStartForReportDate(reportDate, unitsAgo);

      // Add the report to the corresponding unit's list
      if (groupedReports.containsKey(unitStart)) {
        groupedReports[unitStart]!.add(report);
      } else if (groupedBy == GroupBy.day) {
        final timeDifference = reportDate
            .difference(unitsAgo)
            .inDays;
        if (timeDifference < numberOfPeriodsToShow) {
          final nearestDayKey = DateFormat('yyyy-MM-dd')
              .format(unitsAgo.add(Duration(days: timeDifference)));
          groupedReports[nearestDayKey]!.add(report);
        }
      }
    }

    return groupedReports;
  }

  /// Calculate the time period (days, weeks, or months) to group the reports by
  DateTime _calculateUnitsAgo(DateTime now, int index) {
    switch (groupedBy) {
      case GroupBy.month:
        return DateTime(
          now.year,
          now.month - (numberOfPeriodsToShow - 1 + index),
        );
      case GroupBy.week:
        return Helper.getMondayOfTheWeek(
          now.subtract(Duration(days: 7 * (numberOfPeriodsToShow + index))),
        );
      case GroupBy.day:
        return now.subtract(Duration(days: numberOfPeriodsToShow - 1 + index));
    }
  }

  /// Initialize the map of grouped reports with empty lists for each period
  void _initializeGroupedReports(
      Map<String, List<HappinessReportModel>> groupedReports,
      DateTime unitsAgo,
      List<HappinessReportModel> reports,) {
    for (var i = 0; i < numberOfPeriodsToShow; i++) {
      DateTime newUnitsAgo;
      switch (groupedBy) {
        case GroupBy.month:
          newUnitsAgo = DateTime(unitsAgo.year, unitsAgo.month + i);
          break;
        case GroupBy.week:
          newUnitsAgo = unitsAgo.add(Duration(days: 7 * i));
          break;
        case GroupBy.day:
          newUnitsAgo = unitsAgo.add(Duration(days: i));
          break;
      }
      final unitStart = DateFormat('yyyy-MM-dd').format(newUnitsAgo);

      // Filter reports that fall on the start date of the period
      final matchingReports = reports.where((report) {
        final reportDate = Helper.formatter.parse(report.date);
        if (groupedBy == GroupBy.day) {
          return reportDate.year == newUnitsAgo.year &&
              reportDate.month == newUnitsAgo.month &&
              reportDate.day == newUnitsAgo.day;
        } else {
          return reportDate.isAtSameMomentAs(newUnitsAgo);
        }
      }).toList();

      groupedReports[unitStart] = matchingReports;
    }
  }

  /// Find the unit start date for the report date
  String _findUnitStartForReportDate(DateTime reportDate, DateTime unitsAgo) {
    String unitStart;
    switch (groupedBy) {
      case GroupBy.month:
        unitStart = DateFormat('yyyy-MM-dd').format(
          DateTime(
            reportDate.year,
            reportDate.month,
          ),
        );
        break;
      case GroupBy.week:
        final weeksDifference = Helper.getWeeksDifference(unitsAgo, reportDate);

        unitStart = DateFormat('yyyy-MM-dd').format(
          Helper.addWeeksToDate(unitsAgo, weeksDifference),
        );
        break;
      case GroupBy.day:
        if (reportDate.isAtSameMomentAs(unitsAgo)) {
          unitStart = DateFormat('yyyy-MM-dd').format(unitsAgo);
        } else {
          unitStart = DateFormat('yyyy-MM-dd').format(reportDate);
        }
        break;
    }

    return unitStart;
  }

  /// Calculate period averages for each emotion
  List<AverageHappinessReport> _calculateAverages(
      Map<String, List<HappinessReportModel>> groupedReports,) {
    // list to hold the average happiness reports
    final averages = <AverageHappinessReport>[];

    // loop through the grouped reports
    groupedReports.forEach((periodStart, reports) {
      final periodStartDate = DateFormat('yyyy-MM-dd').parse(periodStart);

      int periodNumber;
      switch (groupedBy) {
        case GroupBy.month:
          periodNumber = periodStartDate.month;
          break;
        case GroupBy.week:
          periodNumber = Helper.getWeekNumber(periodStartDate) + 1;
          break;
        case GroupBy.day:
          periodNumber = periodStartDate.day;
          break;
      }

      // check if there are reports in the current period
      final hasReports = reports.isNotEmpty;

      // calculate the average happiness report for the current period
      final averageReport = AverageHappinessReport(
        visibleFeelings: _visibleFeeling,
        periodNumber: periodNumber.toString(),
        month: periodStartDate.month.toString(),
        happinessLevel: hasReports
            ? (reports.fold<double>(
          0,
              (sum, report) => sum + report.happinessLevel,
        ) /
            reports.length)
            : 0,
        sadnessLevel: hasReports
            ? (reports.fold<double>(
          0,
              (sum, report) => sum + report.sadnessLevel,
        ) /
            reports.length)
            : 0,
        angerLevel: hasReports
            ? (reports.fold<double>(
          0,
              (sum, report) => sum + report.angerLevel,
        ) /
            reports.length)
            : 0,
        fearLevel: hasReports
            ? (reports.fold<double>(
          0,
              (sum, report) => sum + report.fearLevel,
        ) /
            reports.length)
            : 0,
        year: periodStartDate.year.toString(),
        hasReports: hasReports,
      );

      // add the average report to the list
      averages.add(averageReport);
    });

    return averages;
  }
}

/// Average happiness data holder
class AverageHappinessReport {
  AverageHappinessReport({
    required this.month,
    required this.year,
    required this.periodNumber,
    required this.happinessLevel,
    required this.sadnessLevel,
    required this.angerLevel,
    required this.fearLevel,
    required this.hasReports,
    required this.visibleFeelings,
  });

  // Period number and year for the report
  final String periodNumber;
  final String month;
  final String year;

  final bool hasReports;
  final Map<String, bool> visibleFeelings;

  // Average levels of each emotion for the period
  double happinessLevel;
  double sadnessLevel;
  double angerLevel;
  double fearLevel;
}

enum GroupBy { month, week, day }
