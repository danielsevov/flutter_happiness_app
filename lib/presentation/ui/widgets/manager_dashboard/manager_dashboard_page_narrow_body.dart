import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:happiness_app/domain/models/user_model.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/daily_intro_report_body_narrow.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/happiness_report.dart';
import 'package:happiness_app/presentation/ui/widgets/introspection_history/introspection_chart.dart';
import 'package:happiness_app/presentation/ui/widgets/introspection_history/introspection_list_date_range_header.dart';
import 'package:happiness_app/presentation/ui/widgets/manager_dashboard/grouped_reports.dart';
import 'package:happiness_app/presentation/ui/widgets/weekly_retrospection/weekly_retro_report_body_narrow.dart';

/// This is a body widget for the ManagerDashboard page, which is used when the
/// page is not in wide mode or when the chart is expanded
class ManagerDashboardPageNarrowBody extends StatelessWidget {
  const ManagerDashboardPageNarrowBody({
    required this.constraints,
    required this.isExpanded,
    required this.isLoading,
    required this.fetchDaily,
    required this.mergedReports,
    required this.expand,
    required this.groupMembers,
    required this.filteredReports,
    required this.changeRange,
    super.key,
  });
  final BoxConstraints constraints;
  final bool isExpanded;
  final bool isLoading;
  final bool fetchDaily;
  final List<HappinessReport> mergedReports;
  final List<HappinessReport> filteredReports;
  final List<UserModel> groupMembers;
  final void Function() expand;
  final void Function(DateTimeRange? newRange) changeRange;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // chart widget
        SliverToBoxAdapter(
          child: Container(
            width: constraints.maxWidth > 1200 && !isExpanded
                ? constraints.maxWidth / 2
                : constraints.maxWidth,
            padding: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: isLoading
                  ? const SizedBox()
                  : IntrospectionChart(
                      fetchDaily: fetchDaily,
                      widgets: {
                        for (var e in mergedReports)
                          Helper.formatter.parse(e.report.date): fetchDaily
                              ? DailyIntrospectionReportBodyNarrow(
                                  report: e.report,
                                  constraints: constraints,
                                )
                              : WeeklyRetrospectionReportBodyNarrow(
                                  report: e.report,
                                  constraints: constraints,
                                ),
                      },
                      constraints: constraints,
                      onPressed: expand,
                      isExpanded: isExpanded,
                      height: isExpanded ? 400 : constraints.maxHeight / 2,
                    ),
            ),
          ),
        ),

        // list header
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth > 800
                ? (constraints.maxWidth - 800) / 2
                : 0,
          ),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: 55,
              child: DateRangePickerHeader(
                constraints: constraints,
                onDateRangeSelected: changeRange,
              ),
            ),
          ),
        ),

        // list of reports
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth > 800
                ? (constraints.maxWidth - 800) / 2
                : 0,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (groupMembers.isNotEmpty) {
                  return GroupedReports(
                    user: groupMembers[index],
                    reports: filteredReports,
                    constraints: constraints,
                    noEntryString: AppLocalizations.of(context)!.noEntry,
                  );
                } else {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!.noEntry,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: Helper.getNormalTextSize(constraints),
                          ),
                    ),
                  );
                }
              },
              childCount: groupMembers.isNotEmpty ? groupMembers.length : 1,
            ),
          ),
        ),
      ],
    );
  }
}
