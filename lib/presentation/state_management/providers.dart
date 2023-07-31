// coverage:ignore-file

import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:happiness_app/data/datasources/odoo_datasource.dart';
import 'package:happiness_app/data/repositories/happiness_report_repo_impl.dart';
import 'package:happiness_app/data/repositories/happiness_settings_repo_impl.dart';
import 'package:happiness_app/data/repositories/secure_storage_odoo_token_repo_impl.dart';
import 'package:happiness_app/data/repositories/user_repo_impl.dart';
import 'package:happiness_app/domain/repositories/happiness_report_repo.dart';
import 'package:happiness_app/domain/repositories/happiness_settings_repo.dart';
import 'package:happiness_app/domain/repositories/odoo_token_repo.dart';
import 'package:happiness_app/domain/repositories/user_repo.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/presenters/daily_history_presenter.dart';
import 'package:happiness_app/presentation/presenters/daily_intro_presenter.dart';
import 'package:happiness_app/presentation/presenters/manager_dashboard_presenter.dart';
import 'package:happiness_app/presentation/presenters/settings_presenter.dart';
import 'package:happiness_app/presentation/presenters/weekly_retro_presenter.dart';
import 'package:happiness_app/presentation/state_management/language_settings_state.dart';
import 'package:happiness_app/presentation/state_management/user_details_state.dart';

final odooDatasource = OdooDatasource();

final languageSettingsStateProvider = StateProvider<LanguageSettingsState>(
      (ref) => LanguageSettingsState(const Locale('en')),
);

final userDetailsStateProvider = StateProvider<UserDetailsState>(
      (ref) => UserDetailsState(0, 0, 0, false),
);

final managerPresenterProvider = AutoDisposeProvider<ManagerDashboardPresenter>((ref) {
  final managerDashboardPresenter = ManagerDashboardPresenter()
    ..attachRepositories(
      ref.watch(reportRepoProvider),
      ref.watch(userRepoProvider),
    );

  return managerDashboardPresenter;
});

final settingsPresenterProvider = AutoDisposeProvider<SettingsPresenter>((ref) {
  final settingsPresenter = SettingsPresenter()
    ..attachRepositories(
      ref.watch(settingsRepoProvider),
    );

  return settingsPresenter;
});

final weeklyRetroPresenterProvider = AutoDisposeProvider<WeeklyRetrospectionPresenter>((ref) {
  final userDetailsState = ref.watch(userDetailsStateProvider);
  final weeklyRetrospectionPresenter = WeeklyRetrospectionPresenter(userDetailsState)
    ..attachRepositories(ref.watch(reportRepoProvider));

  return weeklyRetrospectionPresenter;
});

final dailyIntroPresenterProvider = AutoDisposeProvider<DailyIntrospectionPresenter>((ref) {
  final userDetailsState = ref.watch(userDetailsStateProvider);
  final dailyIntrospectionPresenter = DailyIntrospectionPresenter(userDetailsState)
    ..attachRepositories(ref.watch(reportRepoProvider));

  return dailyIntrospectionPresenter;
});

final historyPresenterProvider = AutoDisposeProvider<DailyIntrospectionHistoryPresenter>((ref) {
  final dailyIntrospectionHistoryPresenter = DailyIntrospectionHistoryPresenter()
    ..attachRepositories(ref.watch(reportRepoProvider));

  return dailyIntrospectionHistoryPresenter;
});

final odooRepoProvider = AutoDisposeProvider<OdooTokenRepository>(
      (ref) => SecureStorageOdooTokenRepositoryImplementation(),
);

final userRepoProvider = AutoDisposeProvider<UserRepository>((ref) {
  final userDetailsState = ref.watch(userDetailsStateProvider);
  return UserRepositoryImplementation(
    odooDatasource,
    Helper.userModel,
    userDetailsState,
  );
});

final reportRepoProvider = AutoDisposeProvider<HappinessReportRepository>((ref) {
  final userDetailsState = ref.watch(userDetailsStateProvider);
  return HappinessReportRepositoryImplementation(
    odooDatasource,
    Helper.happinessReportModel,
    userDetailsState,
  );
});

final settingsRepoProvider = AutoDisposeProvider<HappinessSettingsRepository>((ref) {
  final userDetailsState = ref.watch(userDetailsStateProvider);
  return HappinessSettingsRepositoryImplementation(
    odooDatasource,
    Helper.happinessSettingsModel,
    userDetailsState,
  );
});

final initOdooMethodProvider = StateProvider<Future<void> Function(String, WidgetRef)>(
      (ref) => initializeDatasources,
);

Future<void> initializeDatasources(String sessionId, WidgetRef ref) async {
  // store the odoo token
  await ref.read(odooRepoProvider).saveToken(sessionId);

  // initialize the odoo datasource connector
  await (odooDatasource).initDatasource(sessionId, null, (userDetails) {
    ref.read(userDetailsStateProvider.notifier).state = userDetails;
  });
}