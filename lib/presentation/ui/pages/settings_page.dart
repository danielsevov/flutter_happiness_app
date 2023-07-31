// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, use_decorated_box, inference_failure_on_function_invocation

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:happiness_app/domain/models/happiness_settings_model.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/presenters/settings_presenter.dart';
import 'package:happiness_app/presentation/state_management/language_settings_state.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/dialogs/icon_button_guide_dialog.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/dialogs/lanugage_dialog.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/dialogs/text_button_guide_dialog.dart';
import 'package:happiness_app/presentation/ui/widgets/settings/settings_day_picker.dart';
import 'package:happiness_app/presentation/ui/widgets/settings/settings_switch_tile.dart';
import 'package:happiness_app/presentation/ui/widgets/settings/settings_time_picker.dart';
import 'package:happiness_app/presentation/views/pages/settings_page_view.dart';

import '../../state_management/providers.dart';
import 'dashboard_page.dart';

/// The settings page is the one, which is used by the user for
/// updating their user settings, like locale, notifications and data settings.
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key, required this.settingsPresenter});
  final SettingsPresenter settingsPresenter;

  @override
  ConsumerState createState() => SettingsPageState();
}

class SettingsPageState extends ConsumerState<SettingsPage>
    implements SettingsPageView {
  late HappinessSettingsModel settingsModel;
  bool _isLoading = false;
  bool _isFetched = false;

  late AppLocalizations localizations;

  /// initialize the page view by attaching it to the presenter
  @override
  void initState() {
    widget.settingsPresenter.attach(
      this,
    );

    // start fetching the settings
    widget.settingsPresenter.fetchSettings();

    super.initState();
  }

  /// Function used to apply the user preference.
  @override
  Future<void> notifySettingsImported(HappinessSettingsModel settings) async {
    settingsModel = settings;

    ref
        .watch(languageSettingsStateProvider
            .notifier)
        .update(
          (state) => LanguageSettingsState(Locale(settings.locale ?? 'en')),
        );

    _isFetched = true;
    setInProgress(false);
  }

  /// Function to notify the user that settings could not be fetched.
  @override
  void notifySettingsNotFetched() {
    Helper.makeToast(
      context,
      localizations.noSettingsFetched,
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

  /// detach the view from the presenter
  @override
  void deactivate() {
    widget.settingsPresenter.detach();
    super.deactivate();
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

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 5,
            centerTitle: true,
            title: Text(
              localizations.mySettings,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: Helper.getBigHeadingSize(constraints),
                  ),
            ),
            actions: [
              // change language button
              IconButton(
                onPressed: () {
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
                        Animation<double> animation, Animation<double> secondaryAnimation) {
                      // Get the current locale from the language settings state provider
                      final currentLocale = ref
                          .watch(languageSettingsStateProvider)
                          .currentLocale;
                      return LanguageDialog(
                        constraints: constraints,
                        currentLocale: currentLocale,
                        onChanged: (String locale) {
                          widget.settingsPresenter.changeLocaleSettings(locale);
                        },
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.language,
                  color: Theme.of(context).colorScheme.background,
                  size: Helper.getIconSize(constraints),
                ),
              ),
            ],
          ),
          body: _isLoading || !_isFetched
              ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          localizations.dailyNotifications,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize:
                                    Helper.getSmallHeadingSize(constraints),
                              ),
                        ),
                        const SizedBox(height: 10),
                        SettingsSwitchTile(
                          onChanged: (bool value) {
                            widget.settingsPresenter
                                .changeNotificationsSettings(
                              monday: value,
                              tuesday: settingsModel.tuesday,
                              wednesday: settingsModel.wednesday,
                              thursday: settingsModel.thursday,
                              friday: settingsModel.friday,
                              saturday: settingsModel.saturday,
                              sunday: settingsModel.sunday,
                              timeOfTheDay: settingsModel.timeOfTheDay,
                              weeklyDayOfTheWeek:
                                  settingsModel.weeklyReviewDayOfWeek,
                              weeklyTimeOfTheDay:
                                  settingsModel.weeklyReviewTimeOfTheDay,
                            );
                          },
                          constraints: constraints,
                          value: settingsModel.monday,
                          title: localizations.notifyMeOn(localizations.monday),
                        ),
                        SettingsSwitchTile(
                          onChanged: (bool value) {
                            widget.settingsPresenter
                                .changeNotificationsSettings(
                              monday: settingsModel.monday,
                              tuesday: value,
                              wednesday: settingsModel.wednesday,
                              thursday: settingsModel.thursday,
                              friday: settingsModel.friday,
                              saturday: settingsModel.saturday,
                              sunday: settingsModel.sunday,
                              timeOfTheDay: settingsModel.timeOfTheDay,
                              weeklyDayOfTheWeek:
                                  settingsModel.weeklyReviewDayOfWeek,
                              weeklyTimeOfTheDay:
                                  settingsModel.weeklyReviewTimeOfTheDay,
                            );
                          },
                          constraints: constraints,
                          value: settingsModel.tuesday,
                          title: localizations.notifyMeOn(
                            localizations.tuesday,
                          ),
                        ),
                        SettingsSwitchTile(
                          onChanged: (bool value) {
                            widget.settingsPresenter
                                .changeNotificationsSettings(
                              monday: settingsModel.monday,
                              tuesday: settingsModel.tuesday,
                              wednesday: value,
                              thursday: settingsModel.thursday,
                              friday: settingsModel.friday,
                              saturday: settingsModel.saturday,
                              sunday: settingsModel.sunday,
                              timeOfTheDay: settingsModel.timeOfTheDay,
                              weeklyDayOfTheWeek:
                                  settingsModel.weeklyReviewDayOfWeek,
                              weeklyTimeOfTheDay:
                                  settingsModel.weeklyReviewTimeOfTheDay,
                            );
                          },
                          constraints: constraints,
                          value: settingsModel.wednesday,
                          title: localizations.notifyMeOn(
                            localizations.wednesday,
                          ),
                        ),
                        SettingsSwitchTile(
                          onChanged: (bool value) {
                            widget.settingsPresenter
                                .changeNotificationsSettings(
                              monday: settingsModel.monday,
                              tuesday: settingsModel.tuesday,
                              wednesday: settingsModel.wednesday,
                              thursday: value,
                              friday: settingsModel.friday,
                              saturday: settingsModel.saturday,
                              sunday: settingsModel.sunday,
                              timeOfTheDay: settingsModel.timeOfTheDay,
                              weeklyDayOfTheWeek:
                                  settingsModel.weeklyReviewDayOfWeek,
                              weeklyTimeOfTheDay:
                                  settingsModel.weeklyReviewTimeOfTheDay,
                            );
                          },
                          constraints: constraints,
                          value: settingsModel.thursday,
                          title: localizations.notifyMeOn(
                            localizations.thursday,
                          ),
                        ),
                        SettingsSwitchTile(
                          onChanged: (bool value) {
                            widget.settingsPresenter
                                .changeNotificationsSettings(
                              monday: settingsModel.monday,
                              tuesday: settingsModel.tuesday,
                              wednesday: settingsModel.wednesday,
                              thursday: settingsModel.thursday,
                              friday: value,
                              saturday: settingsModel.saturday,
                              sunday: settingsModel.sunday,
                              timeOfTheDay: settingsModel.timeOfTheDay,
                              weeklyDayOfTheWeek:
                                  settingsModel.weeklyReviewDayOfWeek,
                              weeklyTimeOfTheDay:
                                  settingsModel.weeklyReviewTimeOfTheDay,
                            );
                          },
                          constraints: constraints,
                          value: settingsModel.friday,
                          title: localizations.notifyMeOn(localizations.friday),
                        ),
                        SettingsSwitchTile(
                          onChanged: (bool value) {
                            widget.settingsPresenter
                                .changeNotificationsSettings(
                              monday: settingsModel.monday,
                              tuesday: settingsModel.tuesday,
                              wednesday: settingsModel.wednesday,
                              thursday: settingsModel.thursday,
                              friday: settingsModel.friday,
                              saturday: value,
                              sunday: settingsModel.sunday,
                              timeOfTheDay: settingsModel.timeOfTheDay,
                              weeklyDayOfTheWeek:
                                  settingsModel.weeklyReviewDayOfWeek,
                              weeklyTimeOfTheDay:
                                  settingsModel.weeklyReviewTimeOfTheDay,
                            );
                          },
                          constraints: constraints,
                          value: settingsModel.saturday,
                          title: localizations.notifyMeOn(
                            localizations.saturday,
                          ),
                        ),
                        SettingsSwitchTile(
                          onChanged: (bool value) {
                            widget.settingsPresenter
                                .changeNotificationsSettings(
                              monday: settingsModel.monday,
                              tuesday: settingsModel.tuesday,
                              wednesday: settingsModel.wednesday,
                              thursday: settingsModel.thursday,
                              friday: settingsModel.friday,
                              saturday: settingsModel.saturday,
                              sunday: value,
                              timeOfTheDay: settingsModel.timeOfTheDay,
                              weeklyDayOfTheWeek:
                                  settingsModel.weeklyReviewDayOfWeek,
                              weeklyTimeOfTheDay:
                                  settingsModel.weeklyReviewTimeOfTheDay,
                            );
                          },
                          constraints: constraints,
                          value: settingsModel.sunday,
                          title: localizations.notifyMeOn(localizations.sunday),
                        ),
                        SettingsTimePicker(
                          onChanged: (String timeOfDay) {
                            widget.settingsPresenter
                                .changeNotificationsSettings(
                              monday: settingsModel.monday,
                              tuesday: settingsModel.tuesday,
                              wednesday: settingsModel.wednesday,
                              thursday: settingsModel.thursday,
                              friday: settingsModel.friday,
                              saturday: settingsModel.saturday,
                              sunday: settingsModel.sunday,
                              timeOfTheDay: timeOfDay,
                              weeklyDayOfTheWeek:
                                  settingsModel.weeklyReviewDayOfWeek,
                              weeklyTimeOfTheDay:
                                  settingsModel.weeklyReviewTimeOfTheDay,
                            );
                          },
                          constraints: constraints,
                          initialTime: settingsModel.timeOfTheDay ?? '16:00',
                          type: 'daily',
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: constraints.maxWidth / 2,
                          child: Divider(
                            thickness: 1,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          localizations.weeklyNotifications,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize:
                                    Helper.getSmallHeadingSize(constraints),
                              ),
                        ),
                        const SizedBox(height: 10),
                        SettingsDayPicker(
                          onChanged: (Day day) {
                            widget.settingsPresenter
                                .changeNotificationsSettings(
                              monday: settingsModel.monday,
                              tuesday: settingsModel.tuesday,
                              wednesday: settingsModel.wednesday,
                              thursday: settingsModel.thursday,
                              friday: settingsModel.friday,
                              saturday: settingsModel.saturday,
                              sunday: settingsModel.sunday,
                              timeOfTheDay: settingsModel.timeOfTheDay,
                              weeklyDayOfTheWeek: day,
                              weeklyTimeOfTheDay:
                                  settingsModel.weeklyReviewTimeOfTheDay,
                            );
                          },
                          initialDay: settingsModel.weeklyReviewDayOfWeek,
                          constraints: constraints,
                        ),
                        SettingsTimePicker(
                          onChanged: (String timeOfDay) {
                            widget.settingsPresenter
                                .changeNotificationsSettings(
                              monday: settingsModel.monday,
                              tuesday: settingsModel.tuesday,
                              wednesday: settingsModel.wednesday,
                              thursday: settingsModel.thursday,
                              friday: settingsModel.friday,
                              saturday: settingsModel.saturday,
                              sunday: settingsModel.sunday,
                              timeOfTheDay: settingsModel.timeOfTheDay,
                              weeklyDayOfTheWeek:
                                  settingsModel.weeklyReviewDayOfWeek,
                              weeklyTimeOfTheDay: timeOfDay,
                            );
                          },
                          constraints: constraints,
                          initialTime:
                              settingsModel.weeklyReviewTimeOfTheDay ?? '16:00',
                          type: 'weekly',
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: constraints.maxWidth / 2,
                          child: Divider(
                            thickness: 1,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              localizations.dataSettings,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize:
                                        Helper.getSmallHeadingSize(constraints),
                                  ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: IconButtonGuideDialog(
                                title: localizations.dataSettings,
                                guideline: localizations.dataPrivacyGuide,
                                constraints: constraints,
                                close: localizations.close,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SettingsSwitchTile(
                          onChanged: (bool value) {
                            widget.settingsPresenter
                                .changeDataSettings(canShare: value);
                          },
                          constraints: constraints,
                          value: settingsModel.canShare,
                          title: localizations.canShare,
                        ),
                        TextButtonGuideDialog(
                          constraints: constraints,
                          title: localizations.dataPrivacyPolicy,
                          bodyText: localizations.privacyPolicy,
                          buttonLabel: localizations.dataPrivacyPolicy,
                          close: localizations.close,
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
