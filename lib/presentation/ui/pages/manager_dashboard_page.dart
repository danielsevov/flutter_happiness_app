// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, use_decorated_box, inference_failure_on_function_invocation

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:happiness_app/domain/models/user_model.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/presenters/manager_dashboard_presenter.dart';
import 'package:happiness_app/presentation/ui/pages/dashboard_page.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/happiness_report.dart';
import 'package:happiness_app/presentation/ui/widgets/manager_dashboard/manager_dashboard_page_narrow_body.dart';
import 'package:happiness_app/presentation/ui/widgets/manager_dashboard/manager_dashboard_page_wide_body.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/toggle_button.dart';
import 'package:happiness_app/presentation/views/pages/manager_dashboard_page_view.dart';

import '../../state_management/providers.dart';

/// This page is used by the managers to overview the report entries
/// of their employees and to explore data visualizations
class ManagerDashboardPage extends ConsumerStatefulWidget {
  const ManagerDashboardPage({super.key, required this.presenter});
  final ManagerDashboardPresenter presenter;

  @override
  ConsumerState createState() => ManagerDashboardPageState();
}

class ManagerDashboardPageState extends ConsumerState<ManagerDashboardPage>
    implements ManagerDashboardPageView {
  List<HappinessReport> reports = [];
  List<HappinessReport> mergedReports = [];
  List<UserModel> groupMembers = [];
  bool isLoading = false;
  bool isExpanded = false;
  bool fetchDaily = false;
  DateTimeRange? dateRange;

  /// Function used for filtering the list of reports based on selected
  /// date time range.
  List<HappinessReport> filteredReports(List<HappinessReport> reports) {
    if (dateRange == null) {
      return reports;
    } else {
      return reports.where((report) {
        final reportDate = Helper.formatter.parse(report.report.date);
        return (reportDate.isAtSameMomentAs(dateRange!.start) ||
                reportDate.isAfter(dateRange!.start)) &&
            (reportDate.isAtSameMomentAs(dateRange!.end) ||
                reportDate.isBefore(dateRange!.end));
      }).toList();
    }
  }

  /// initialize the page view by attaching it to the presenter
  @override
  void initState() {
    widget.presenter.attach(
      this,
    );

    // start fetching the reports
    widget.presenter.fetchData(fetchDaily: fetchDaily);

    super.initState();
  }

  /// detach the view from the presenter
  @override
  void deactivate() {
    widget.presenter.detach();
    super.deactivate();
  }

  @override

  /// Function to notify there were no daily introspection reports found.
  void notifyNoReportsFound() {
    setState(() {
      reports = [];
      mergedReports = [];
    });
  }

  @override

  /// Function to notify there was a problem fetching the daily introspection reports.
  void notifyFetchFailed() {
    setState(() {
      reports = [];
      mergedReports = [];
    });

    Helper.makeToast(
      context,
      AppLocalizations.of(context)!.fetchDailyReportsFailed,
    );

    Helper.replacePageWithBackSlideAnimation(
      context,
      DashboardPage(
        odooTokenRepository: ref.watch(odooRepoProvider),
        introspectionPresenter: ref.watch(historyPresenterProvider),
        settingsPresenter: ref.watch(settingsPresenterProvider),
        userDetails: ref.watch(userDetailsStateProvider),
      ),
    );
  }

  @override

  /// Function to notify that all daily reports have been fetched and can be displayed.
  void notifyDataFetched(
    List<HappinessReport> reportWidgets,
    List<UserModel> team,
    List<HappinessReport> mergedList,
  ) {
    setState(() {
      groupMembers = team;
      reports = reportWidgets;
      mergedReports = mergedList;
    });
  }

  @override

  /// Function to set if data is currently being fetched and an loading indicator should be displayed.
  void setInProgress(bool inProgress) {
    setState(() {
      isLoading = inProgress;
    });
  }

  /// Function used for changing the type of reports to fetch
  void changeReportType(int? newValue) {
    setState(() {
      groupMembers.clear();
      fetchDaily = !fetchDaily;
    });
    widget.presenter.fetchData(fetchDaily: fetchDaily);
  }

  /// Function used for grouping the reports by user
  List<Widget> groupReportsByUser(BoxConstraints constraints) {
    final groupedReports = <Widget>[];

    for (final user in groupMembers) {
      final userReports = reports
          .where((report) => report.report.employeeId == user.id)
          .toList();

      groupedReports.add(
        ExpansionTile(
          title: Text(
            user.name ?? AppLocalizations.of(context)!.unknown,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: Helper.getNormalTextSize(constraints),
                ),
          ),
          children: [
            for (var i = 0; i < userReports.length; i++) userReports[i],
            if (userReports.isNotEmpty)
              Divider(color: Theme.of(context).colorScheme.primary),
          ],
        ),
      );
    }

    return groupedReports;
  }

  @override
  Widget build(BuildContext context) {
    var filteredReportsList = this.filteredReports(reports);
    var filteredMembersList = groupMembers.where((element) => filteredReportsList.map((e) => e.report.employeeId).contains(element.id)).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(top: 70),
            child: CustomToggleButton(
                changeReportType: changeReportType,
                fetchDaily: fetchDaily,
                constraints: constraints),
          ),
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Helper.replacePageWithBackSlideAnimation(
                  context,
                  DashboardPage(
                    odooTokenRepository: ref.watch(odooRepoProvider),
                    introspectionPresenter: ref.watch(historyPresenterProvider),
                    settingsPresenter: ref.watch(settingsPresenterProvider),
                    userDetails: ref.watch(userDetailsStateProvider),
                  ),
                );
              },
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.background,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 5,
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context)!.managerDashboard,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: Helper.getBigHeadingSize(constraints),
                  ),
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                opacity: 0.5,
                image: AssetImage('assets/images/green_waves.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: isLoading
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
                : SafeArea(
                    minimum: const EdgeInsets.only(top: 70),
                    child: isExpanded || constraints.maxWidth < 1200
                        ? ManagerDashboardPageNarrowBody(
                            constraints: constraints,
                            isExpanded: isExpanded,
                            isLoading: isLoading,
                            fetchDaily: fetchDaily,
                            mergedReports: mergedReports,
                            expand: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                            groupMembers: filteredMembersList,
                            filteredReports: filteredReportsList,
                            changeRange: (DateTimeRange? newRange) {
                              setState(() {
                                dateRange = newRange;
                              });
                            },
                          )
                        : ManagerDashboardPageWideBody(
                            constraints: constraints,
                            isExpanded: isExpanded,
                            isLoading: isLoading,
                            fetchDaily: fetchDaily,
                            mergedReports: mergedReports,
                            expand: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                            groupMembers: filteredMembersList,
                            filteredReports: filteredReportsList,
                            changeRange: (DateTimeRange? newRange) {
                              setState(() {
                                dateRange = newRange;
                              });
                            },
                          ),
                  ),
          ),
        );
      },
    );
  }
}
