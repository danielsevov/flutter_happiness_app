// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, use_decorated_box, inference_failure_on_function_invocation

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/presenters/daily_history_presenter.dart';
import 'package:happiness_app/presentation/state_management/providers.dart';
import 'package:happiness_app/presentation/ui/pages/dashboard_page.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/daily_intro_report_body_narrow.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/happiness_report.dart';
import 'package:happiness_app/presentation/ui/widgets/introspection_history/introspection_calendar.dart';
import 'package:happiness_app/presentation/ui/widgets/introspection_history/introspection_chart.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/toggle_button.dart';
import 'package:happiness_app/presentation/ui/widgets/reward_system/progress_bookshelf.dart';
import 'package:happiness_app/presentation/ui/widgets/reward_system/weekly_reward_circle.dart';
import 'package:happiness_app/presentation/views/pages/daily_history_page_view.dart';

class IntrospectionHistoryPage extends ConsumerStatefulWidget {
  const IntrospectionHistoryPage({super.key, required this.presenter});
  final DailyIntrospectionHistoryPresenter presenter;

  @override
  ConsumerState createState() => IntrospectionHistoryPageState();
}

class IntrospectionHistoryPageState
    extends ConsumerState<IntrospectionHistoryPage>
    implements DailyIntrospectionHistoryPageView {
  List<HappinessReport> reports = [];
  List<Widget> rewards = [];
  List<HappinessReport> reportsToShow = [];
  List<RewardData> rewardDataList = [];
  bool _isLoading = false;
  bool _isExpanded = false;
  bool fetchDaily = true;

  late AppLocalizations localizations;

  /// initialize the page view by attaching it to the presenter
  @override
  void initState() {
    widget.presenter.attach(
      this,
    );

    // start fetching the reports
    widget.presenter.fetchReports(
      fetchDaily: fetchDaily,
    );

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
      reportsToShow = [];
    });
  }

  @override

  /// Function to notify there was a problem fetching the daily introspection reports.
  void notifyFetchFailed(String errorMessage) {
    Helper.makeToast(
      context,
      localizations.fetchDailyReportsFailed,
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
  void notifyReportsFetched(
      List<HappinessReport> reportWidgets,
      bool hasMoreReports,
      int dailyStreak,
      int weeklyStreak,
      int? dailyMaxStreak,
      int? weeklyMaxStreak,
      int? longestDaily,
      int? longestWeekly) {
    setState(() {
      reports = reportWidgets;
      reportsToShow = reportWidgets.length <= 10
          ? reportWidgets
          : reportWidgets.sublist(0, 10);
      var reportList = reports.map((e) => e.report).toList();
      rewardDataList.clear();

      for (var report in reportList) {
        DateTime parsedDate = Helper.formatter.parse(report.date);
        String id = report.isDailyReport
            ? 'Week ${Helper.getWeekNumber(parsedDate)}, ${parsedDate.year}'
            : '\n${Helper.getMonthName(parsedDate.month)} ${parsedDate.year}';

        if (!rewardDataList.any((data) => data.id == id)) {
          int count = reportList.where((report) {
            String reportId = reportList.first.isDailyReport
                ? 'Week ${Helper.getWeekNumber(Helper.formatter.parse(report.date))}, ${Helper.formatter.parse(report.date).year}'
                : '\n${Helper.getMonthName(Helper.formatter.parse(report.date).month)} ${Helper.formatter.parse(report.date).year}';

            return reportId == id;
          }).length;

          rewardDataList
              .add(RewardData(id, count, !reportList.first.isDailyReport));
        }
      }

      rewards = rewardDataList
          .map((data) => Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      data.id,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.w500,
                            fontSize: Helper.getNormalTextSize(BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width,
                              maxHeight: MediaQuery.of(context).size.height,
                            )),
                          ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        width: 300,
                        child: WeeklyRewardCircle(
                          streak: data.number,
                          isWeekly: data.isWeekly,
                          localizations: localizations,
                          mini: true,
                        )),
                  ],
                ),
              ))
          .toList();
    });
  }

  @override

  /// Function to set if data is currently being fetched and an loading indicator should be displayed.
  void setInProgress(bool inProgress) {
    setState(() {
      _isLoading = inProgress;
    });
  }

  /// Function used for changing the type of reports to fetch
  void changeReportType(int? newValue) {
    setState(() {
      fetchDaily = !fetchDaily;
    });
    widget.presenter.fetchReports(
      fetchDaily: fetchDaily,
    );
  }

  @override
  Widget build(BuildContext context) {
    localizations = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(top: 70),
            child: CustomToggleButton(
              changeReportType: changeReportType,
              fetchDaily: fetchDaily,
              constraints: constraints,
            ),
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
              localizations.introHistory,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: Helper.getBigHeadingSize(constraints),
                  ),
            ),
          ),
          body: SafeArea(
            minimum: const EdgeInsets.only(top: 70),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  opacity: 0.5,
                  image: AssetImage('assets/images/green_waves.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Container(
                      width: constraints.maxWidth > 1200 && !_isExpanded
                          ? constraints.maxWidth / 2
                          : constraints.maxWidth,
                      padding: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _isLoading
                            ? const SizedBox()
                            : IntrospectionChart(
                                widgets: {
                                  for (var e in reports)
                                    Helper.formatter.parse(e.report.date):
                                        DailyIntrospectionReportBodyNarrow(
                                      report: e.report,
                                      constraints: constraints,
                                    )
                                },
                                constraints: constraints,
                                onPressed: () {
                                  setState(() {
                                    _isExpanded = !_isExpanded;
                                  });
                                },
                                isExpanded: _isExpanded,
                                fetchDaily: fetchDaily,
                                height: 400,
                              ),
                      ),
                    ),
                    Column(
                      children: [
                        if (constraints.maxWidth > 1200 && !_isExpanded)
                          const SizedBox(
                            height: 50,
                          )
                        else
                          const SizedBox(),
                        Container(
                          width: constraints.maxWidth > 1200 && !_isExpanded
                              ? constraints.maxWidth / 2
                              : constraints.maxWidth > 800
                                  ? 800
                                  : constraints.maxWidth,
                          padding: const EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _isLoading
                                ? const SizedBox()
                                : IntrospectionCalendar(
                                    widgets: {
                                      for (var e in reports)
                                        Helper.formatter.parse(e.report.date):
                                            DailyIntrospectionReportBodyNarrow(
                                          report: e.report,
                                          constraints: constraints,
                                        )
                                    },
                                    constraints: constraints,
                                  ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          // introspection feed header
                          Text(
                            AppLocalizations.of(context)!
                                .mostRecentIntrospections,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: Helper.getSmallHeadingSize(
                                    constraints,
                                  ),
                                ),
                          ),
                          SizedBox(
                            width: constraints.maxWidth < 800
                                ? constraints.maxWidth
                                : 800,
                            child: Divider(
                              color: Theme.of(context).colorScheme.primary,
                              thickness: 1,
                            ),
                          ),

                          // list of reports (introspection feed)
                          if (_isLoading)
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            )
                          else
                            Column(
                              children: reportsToShow.isNotEmpty
                                  ? reportsToShow
                                  : [
                                      Text(
                                        AppLocalizations.of(context)!.noEntry,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontSize:
                                                  Helper.getNormalTextSize(
                                                constraints,
                                              ),
                                            ),
                                      ),
                                    ],
                            ),

                          SizedBox(
                            height: !_isLoading ? 40 : 0,
                          ),
                          Text(
                            AppLocalizations.of(context)!.myProgress,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: Helper.getSmallHeadingSize(
                                    constraints,
                                  ),
                                ),
                          ),
                          SizedBox(
                            width: constraints.maxWidth < 800
                                ? constraints.maxWidth
                                : 800,
                            child: Divider(
                              color: Theme.of(context).colorScheme.primary,
                              thickness: 1,
                            ),
                          ),

                          if (_isLoading)
                            SizedBox()
                          else
                            SizedBox(
                                width: constraints.maxWidth > 1200
                                    ? 1200
                                    : constraints.maxWidth,
                                height: ((rewardDataList.length /
                                    (constraints.maxWidth ~/ 30.0))
                                    .ceil() *
                                    250.0) +
                                    50.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 50, right: 50, bottom: 60,),
                                  child: ProgressBookshelf(
                                      rewardData:
                                      rewardDataList.reversed.toList()),
                                )),

                          const SizedBox(
                            height: 60,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class RewardData {
  final String id;
  final int number;
  final bool isWeekly;

  RewardData(this.id, this.number, this.isWeekly);
}
