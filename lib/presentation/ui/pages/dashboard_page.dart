// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, use_decorated_box, inference_failure_on_function_invocation

import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:happiness_app/domain/models/happiness_settings_model.dart';
import 'package:happiness_app/domain/repositories/odoo_token_repo.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/presenters/daily_history_presenter.dart';
import 'package:happiness_app/presentation/presenters/settings_presenter.dart';
import 'package:happiness_app/presentation/state_management/language_settings_state.dart';
import 'package:happiness_app/presentation/state_management/user_details_state.dart';
import 'package:happiness_app/presentation/ui/pages/daily_intro_page.dart';
import 'package:happiness_app/presentation/ui/pages/introspection_history_page.dart';
import 'package:happiness_app/presentation/ui/pages/login_page.dart';
import 'package:happiness_app/presentation/ui/pages/manager_dashboard_page.dart';
import 'package:happiness_app/presentation/ui/pages/settings_page.dart';
import 'package:happiness_app/presentation/ui/pages/weekly_retro_page.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/report_date_picker.dart';
import 'package:happiness_app/presentation/ui/widgets/drawer/custom_drawer.dart';
import 'package:happiness_app/presentation/ui/widgets/drawer/custom_drawer_body_item.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/dialogs/custom_dialog.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/toggle_button.dart';
import 'package:happiness_app/presentation/views/pages/daily_history_page_view.dart';
import 'package:happiness_app/presentation/views/pages/settings_page_view.dart';
import 'package:intl/intl.dart';

import '../../state_management/providers.dart';

/// The dashboard page is the one, which is the home screen and
/// allows the user to change settings, log out, and navigate to the other pages.
class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({
    super.key,
    required this.userDetails,
    required this.odooTokenRepository,
    required this.introspectionPresenter,
    required this.settingsPresenter,
  });
  final DailyIntrospectionHistoryPresenter introspectionPresenter;
  final SettingsPresenter settingsPresenter;
  final OdooTokenRepository odooTokenRepository;
  final UserDetailsState userDetails;

  @override
  ConsumerState createState() => DashboardPageState();
}

class DashboardPageState extends ConsumerState<DashboardPage>
    implements DailyIntrospectionHistoryPageView, SettingsPageView {
  List<Widget> reports = [];
  bool _isLoading = false;
  int pageLimit = 10;
  int currentPageIndex = 0;
  bool fetchDaily = true;
  bool hasMoreReports = false;
  String dateString = '';

  late AppLocalizations localizations;

  /// initialize the page view by attaching it to the presenter
  @override
  void initState() {
    widget.introspectionPresenter.attach(
      this,
    );
    widget.settingsPresenter.attach(
      this,
    );

    // start fetching the reports and settings
    widget.introspectionPresenter.fetchReports(
      pageLimit: pageLimit,
      currentPageIndex: currentPageIndex,
      fetchDaily: fetchDaily,
    );
    widget.settingsPresenter.fetchSettings();

    super.initState();
  }

  /// Function used for changing the type of reports to fetch
  void changeReportType(int? newValue) {
    setState(() {
      dateString = '';
      fetchDaily = !fetchDaily;
      currentPageIndex = 0;
      pageLimit = 10;
    });

    widget.introspectionPresenter.fetchReports(
      pageLimit: pageLimit,
      currentPageIndex: currentPageIndex,
      fetchDaily: fetchDaily,
    );
  }

  /// Function used to apply the user preference.
  @override
  Future<void> notifySettingsImported(HappinessSettingsModel settings) async {
    ref.read(languageSettingsStateProvider.notifier).update(
          (state) => LanguageSettingsState(Locale(settings.locale ?? 'en')),
        );
  }

  /// Function to notify the user that settings could not be fetched.
  @override
  void notifySettingsNotFetched() {
    Helper.makeToast(
      context,
      localizations.noSettingsFetched,
    );
  }

  /// detach the view from the presenter
  @override
  void deactivate() {
    widget.introspectionPresenter.detach();
    widget.settingsPresenter.detach();
    super.deactivate();
  }

  @override

  /// Function to notify there were no daily introspection reports found.
  void notifyNoReportsFound() {
    if (currentPageIndex == 0) {
      setState(() {
        reports.clear();
      });
    } else {
      currentPageIndex--;
      widget.introspectionPresenter.fetchReports(
        pageLimit: pageLimit,
        currentPageIndex: currentPageIndex,
        fetchDaily: fetchDaily,
      );
    }
  }

  @override

  /// Function to notify there was a problem fetching the daily introspection reports.
  Future<void> notifyFetchFailed(String errorMessage) async {
    if (errorMessage.contains('SessionExpiredException')) {
      await widget.odooTokenRepository.clearOdooToken();
      Helper.makeToast(
        context,
        localizations.sessionExpired,
      );

      Helper.replacePageWithSlideAnimation(
        context,
        LogInPage(
          odooTokenRepository: ref.watch(odooRepoProvider),
          initializeDatasource: ref.watch(initOdooMethodProvider),
        ),
      );
    } else {
      Helper.makeToast(
        context,
        localizations.fetchDailyReportsFailed,
      );
    }
  }

  @override

  /// Function to notify that all daily reports have been fetched and can be displayed.
  void notifyReportsFetched(List<Widget> reportWidgets, bool hasMore) {
    setState(() {
      reports = reportWidgets;
      hasMoreReports = hasMore;
    });
  }

  @override

  /// Function to set if data is currently being fetched and an loading indicator should be displayed.
  void setInProgress(bool inProgress) {
    setState(() {
      _isLoading = inProgress;
    });
  }

  @override
  Widget build(BuildContext context) {
    localizations = AppLocalizations.of(context)!;

    widget.introspectionPresenter.attach(this);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              dateString.isNotEmpty ? SizedBox() : Padding(
                padding: const EdgeInsets.all(10),
                child: CustomDatePicker(onDateSelected: (DateTime date){
                  setState(() {
                    dateString = DateFormat('yyyy-MM-dd').format(date);
                  });
                }, isDaily: fetchDaily, localizations: localizations, constraints: constraints,),
              ),
              dateString.isNotEmpty ? Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(fetchDaily ? Helper.formatter.format(DateFormat('yyyy-MM-dd').parse(dateString)) : 'Week ${Helper.getWeekNumber(DateFormat('yyyy-MM-dd').parse(dateString))}, ${DateFormat('yyyy-MM-dd').parse(dateString).year}', style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: Helper.getButtonTextSize(constraints),
                        ),),
                        IconButton(onPressed: (){
                          setState(() {
                            dateString = '';
                          });
                        }, icon: Icon(Icons.close, color: Theme.of(context).colorScheme.background, size: Helper.getButtonTextSize(constraints),))
                      ],
                    ),
                  ),
                ),
              ) : SizedBox(),
              FloatingActionButton.extended(
                backgroundColor: Theme.of(context).colorScheme.primary,
                label: Text(
                  fetchDaily
                      ? localizations.dailyIntrospection
                      : localizations.weeklyRetrospection,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.background,
                        fontSize: Helper.getButtonTextSize(constraints),
                      ),
                ),
                icon: Icon(
                  fetchDaily
                      ? FontAwesomeIcons.play
                      : FontAwesomeIcons.magnifyingGlass,
                  color: Theme.of(context).colorScheme.background,
                  size: Helper.getIconSize(constraints),
                ),
                onPressed: () async {
                  Helper.replacePageWithSlideAnimation(
                    context,
                    fetchDaily
                        ? DailyIntrospectionPage(
                            presenter: ref.watch(dailyIntroPresenterProvider),
                      date: dateString.isNotEmpty ? dateString : DateFormat('yyyy-MM-dd').format(DateTime.now())
                          )
                        : WeeklyRetrospectionPage(
                            presenter: ref.watch(weeklyRetroPresenterProvider),
                      weekNumber: dateString.isNotEmpty ? Helper.getWeekNumber(DateFormat('yyyy-MM-dd').parse(dateString)) : Helper.getWeekNumber(DateTime.now()),
                      year: dateString.isNotEmpty ? DateFormat('yyyy-MM-dd').parse(dateString).year : DateTime.now().year,
                          ),
                  );
                },
                heroTag: 'introspectNowButton',
              ),
            ],
          ),
          drawer: CustomDrawer(
            constraints: constraints,
            widgets: [
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  'assets/images/round_logo.png',
                  width: constraints.maxHeight / 5,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              CustomDrawerBodyItem(
                function: () {
                  Helper.replacePageWithSlideAnimation(
                    context,
                    DailyIntrospectionPage(
                        presenter: ref.watch(dailyIntroPresenterProvider),
                  date: DateFormat('yyyy-MM-dd').format(DateTime.now(),),
                  ),
                  );
                },
                title: localizations.dailyIntrospection,
                icon: FontAwesomeIcons.play,
                tileColor: Theme.of(context).colorScheme.primary,
                constraints: constraints,
              ),
              CustomDrawerBodyItem(
                function: () {
                  Helper.replacePageWithSlideAnimation(
                    context,
                    WeeklyRetrospectionPage(
                      presenter: ref.watch(weeklyRetroPresenterProvider),
                      weekNumber: Helper.getWeekNumber(DateTime.now()),
                      year: DateTime.now().year,
                    ),
                  );
                },
                title: localizations.weeklyRetrospection,
                icon: FontAwesomeIcons.magnifyingGlass,
                tileColor: Theme.of(context).colorScheme.primary,
                constraints: constraints,
              ),
              CustomDrawerBodyItem(
                function: () {
                  Navigator.pop(context);
                  Helper.pushPageWithSlideAnimation(
                    context,
                    IntrospectionHistoryPage(
                      presenter: ref.watch(historyPresenterProvider),
                    ),
                  );
                },
                title: localizations.introHistory,
                icon: FontAwesomeIcons.clockRotateLeft,
                tileColor: Theme.of(context).colorScheme.primary,
                constraints: constraints,
              ),
              if (widget.userDetails.currentIsManager)
                CustomDrawerBodyItem(
                  function: () {
                    Helper.replacePageWithSlideAnimation(
                      context,
                      ManagerDashboardPage(
                        presenter: ref.watch(managerPresenterProvider),
                      ),
                    );
                  },
                  title: localizations.managerDashboard,
                  icon: FontAwesomeIcons.chartLine,
                  tileColor: Theme.of(context).colorScheme.primary,
                  constraints: constraints,
                )
              else
                const SizedBox(),
              CustomDrawerBodyItem(
                function: () {
                  Navigator.pop(context);
                  Helper.pushPageWithSlideAnimation(
                    context,
                    SettingsPage(
                      settingsPresenter: ref.watch(settingsPresenterProvider),
                    ),
                  );
                },
                title: localizations.mySettings, //localizations.introHistory,
                icon: FontAwesomeIcons.gear,
                tileColor: Theme.of(context).colorScheme.primary,
                constraints: constraints,
              ),
              CustomDrawerBodyItem(
                function: () {
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: MaterialLocalizations.of(context)
                        .modalBarrierDismissLabel,
                    barrierColor: Colors.black45,
                    transitionDuration: const Duration(milliseconds: 300),
                    transitionBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        Widget child) {
                      // transition to use
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    pageBuilder: (BuildContext buildContext,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      // dialog to show
                      return CustomDialog(
                        title: localizations.logout,
                        bodyText: localizations.sureLogOut,
                        confirm: () async {
                          await widget.odooTokenRepository.clearOdooToken();

                          if (context.mounted) {
                            Navigator.pop(context);
                            Helper.replacePageWithSlideAnimation(
                              context,
                              LogInPage(
                                odooTokenRepository:
                                    ref.watch(odooRepoProvider),
                                initializeDatasource:
                                    ref.watch(initOdooMethodProvider),
                              ),
                            );
                          }
                        },
                        cancel: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        constraints: constraints,
                      );
                    },
                  );
                },
                title: localizations.logout,
                icon: FontAwesomeIcons.arrowRightFromBracket,
                tileColor: Theme.of(context).colorScheme.primary,
                constraints: constraints,
              ),
            ],
          ),
          body: Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/green_waves.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  forceElevated: true,
                  elevation: 5,
                  centerTitle: true,
                  expandedHeight: max(
                    constraints.maxHeight / 6,
                    100,
                  ), // Set a minimum expanded height
                  pinned: true,
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      final currentHeight = constraints.biggest.height;
                      final maxHeight = constraints.maxHeight;
                      const minHeight = kToolbarHeight;
                      final midHeight = (maxHeight + minHeight) / 2;

                      final showTitle = currentHeight == minHeight;
                      final opacity = ((currentHeight - minHeight) /
                              (midHeight - minHeight))
                          .clamp(0.0, 1.0);

                      return FlexibleSpaceBar(
                        centerTitle: true,
                        title: (currentHeight <=
                                midHeight + (Platform.isMacOS ? 0 : 30))
                            ? Text(
                                localizations.dashboard,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      fontSize:
                                          Helper.getBigHeadingSize(constraints),
                                    ),
                              )
                            : null,
                        background: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Positioned.fill(
                              child: Hero(
                                tag: 'logoImage',
                                key: const Key('logoImage'),
                                child: FractionallySizedBox(
                                  heightFactor:
                                      0.8, // Adjust this value based on your preference and add a minimum height factor
                                  child: Image.asset(
                                    'assets/images/rect_logo_plain.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(showTitle ? 0.7 : 0),
                              ),
                            ),
                            Positioned.fill(
                              child: Opacity(
                                opacity: showTitle ? 1 : 1 - opacity,
                                child: Container(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const SizedBox(
                          height: 20,
                        ),

                        // introspection feed header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (currentPageIndex > 0) {
                                  currentPageIndex--;
                                  widget.introspectionPresenter.fetchReports(
                                    pageLimit: pageLimit,
                                    currentPageIndex: currentPageIndex,
                                    fetchDaily: fetchDaily,
                                  );
                                }
                              },
                              icon: Icon(
                                CupertinoIcons.left_chevron,
                                color: currentPageIndex > 0
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.2),
                                size: Helper.getIconSize(constraints),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                localizations.mostRecentIntrospections,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: Helper.getSmallHeadingSize(
                                        constraints,
                                      ),
                                    ),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                if (reports.length == pageLimit &&
                                    hasMoreReports) {
                                  currentPageIndex++;
                                  await widget.introspectionPresenter
                                      .fetchReports(
                                    pageLimit: pageLimit,
                                    currentPageIndex: currentPageIndex,
                                    fetchDaily: fetchDaily,
                                  );
                                }
                              },
                              icon: Icon(
                                CupertinoIcons.right_chevron,
                                color: reports.length == 10 && hasMoreReports
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.2),
                                size: Helper.getIconSize(constraints),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        Center(
                          child: CustomToggleButton(
                            changeReportType: changeReportType,
                            fetchDaily: fetchDaily,
                            constraints: constraints,
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        // list of reports (introspection feed)
                        if (_isLoading)
                          Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        else
                          Column(
                            children: reports.isNotEmpty
                                ? reports
                                : [
                                    Text(
                                      localizations.noEntry,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontSize: Helper.getNormalTextSize(
                                              constraints,
                                            ),
                                          ),
                                    ),
                                  ],
                          ),

                        SizedBox(
                          height: reports.length >= 5
                              ? constraints.maxHeight / 8.5
                              : constraints.maxHeight,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
