// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:happiness_app/domain/models/happiness_report_model.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/presenters/weekly_retro_presenter.dart';
import 'package:happiness_app/presentation/ui/pages/dashboard_page.dart';
import 'package:happiness_app/presentation/ui/widgets/weekly_retrospection/weekly_retro_form.dart';
import 'package:happiness_app/presentation/views/pages/weekly_retro_page_view.dart';

import '../../state_management/providers.dart';

/// The Weekly Retrospection page is the one, which allows the user to fill in and store
/// their weekly report.
class WeeklyRetrospectionPage extends ConsumerStatefulWidget {
  const WeeklyRetrospectionPage({super.key, required this.weekNumber,
    required this.presenter, required this.year});
  final WeeklyRetrospectionPresenter presenter;
  final int weekNumber;
  final int year;

  @override
  ConsumerState createState() => WeeklyRetrospectionPageState();
}

class WeeklyRetrospectionPageState
    extends ConsumerState<WeeklyRetrospectionPage>
    implements WeeklyRetrospectionPageView {
  bool _isLoading = false;
  late WeeklyRetrospectionForm _form;
  HappinessReportModel? todaysReport;

  late AppLocalizations localizations;

  /// initialize the page view by attaching it to the presenter
  @override
  void initState() {
    widget.presenter.attach(this);

    widget.presenter.fetchReport(widget.weekNumber, widget.year);

    super.initState();
  }

  /// detach the view from the presenter
  @override
  void deactivate() {
    widget.presenter.detach();
    super.deactivate();
  }

  /// Function to set if data is currently being fetched and an loading indicator should be displayed.
  @override
  void setInProgress(bool inProgress) {
    setState(() {
      _isLoading = inProgress;
    });
  }

  /// Function to notify the report is saved
  @override
  void notifySaved() {
    Helper.makeToast(context, localizations.weeklyReportSaved);
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

  /// Function to notify the report is not saved
  @override
  void notifyNotSaved() {
    Helper.makeToast(
      context,
      localizations.weeklyReportNotSaved,
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

  /// Function to notify that today's report has been fetched
  @override
  void notifyReportFetched(HappinessReportModel todaysReport) {
    setState(() {
      this.todaysReport = todaysReport;
    });
  }

  @override
  Widget build(BuildContext context) {
    localizations = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        _form = WeeklyRetrospectionForm(
          presenter: widget.presenter,
          constraints: constraints,
          report: todaysReport ?? HappinessReportModel.empty(),
          weekNumber: widget.weekNumber,
          year: widget.year,
        );
        return Scaffold(
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
              localizations.weeklyRetrospection,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: Helper.getBigHeadingSize(constraints),
                  ),
            ),
          ),
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : SingleChildScrollView(child: _form),
        );
      },
    );
  }
}
