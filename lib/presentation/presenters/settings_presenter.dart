// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, use_setters_to_change_properties

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:happiness_app/domain/models/happiness_settings_model.dart';
import 'package:happiness_app/domain/repositories/happiness_settings_repo.dart';
import 'package:happiness_app/main.dart';
import 'package:happiness_app/presentation/presenters/base_presenter.dart';
import 'package:happiness_app/presentation/views/pages/settings_page_view.dart';
import 'package:timezone/timezone.dart' as tz;

class SettingsPresenter extends BasePresenter {
  /// Simple constructor
  SettingsPresenter();
  SettingsPageView? _view;

  late final HappinessSettingsRepository _happinessSettingsRepository;
  late HappinessSettingsModel settings;

  /// Function to attach repositories
  void attachRepositories(
      HappinessSettingsRepository happinessSettingsRepository,
      ) {
    _happinessSettingsRepository = happinessSettingsRepository;
    super.repositoriesAttached = true;
  }

  /// Function to attach a view to the presenter
  void attach(SettingsPageView view) {
    _view = view;
  }

  /// Function to detach the view from the presenter
  void detach() {
    _view = null;
  }

  bool isFirst = true;
  /// Function to fetch the user settings object
  Future<void> fetchSettings() async {
    //_view?.setInProgress(true);

    // Fetch settings
    settings = await _happinessSettingsRepository.getMySettings();

    // Schedule notifications based on the selected day and time
    await _scheduleNotifications();

    // Notify user that settings are imported
    _view?.notifySettingsImported(settings);

    //_view?.setInProgress(false);
  }

  /// Function to update the locale settings
  Future<void> changeLocaleSettings(String locale) async {
    _view?.setInProgress(true);
    settings.locale = locale;
    settings = await _happinessSettingsRepository.update(settings);
    _view?.notifySettingsImported(settings);

    _view?.setInProgress(false);
  }

  /// Function to update the notifications settings
  Future<void> changeNotificationsSettings({
    required bool monday,
    required bool tuesday,
    required bool wednesday,
    required bool thursday,
    required bool friday,
    required bool saturday,
    required bool sunday,
    String? timeOfTheDay,
    required Day weeklyDayOfTheWeek,
    String? weeklyTimeOfTheDay,
  }) async {
    //_view?.setInProgress(true);
    settings
      ..monday = monday
      ..tuesday = tuesday
      ..wednesday = wednesday
      ..thursday = thursday
      ..friday = friday
      ..saturday = saturday
      ..sunday = sunday
      ..timeOfTheDay = timeOfTheDay
      ..weeklyReviewDayOfWeek = weeklyDayOfTheWeek
      ..weeklyReviewTimeOfTheDay = weeklyTimeOfTheDay;

    // update the data model
    settings = await _happinessSettingsRepository.update(settings);

    // fetch the updated data and update notification settings
    await fetchSettings();

    //_view?.setInProgress(false);
  }

  /// Function to update the data settings
  Future<void> changeDataSettings({required bool canShare}) async {
    //_view?.setInProgress(true);
    settings.canShare = canShare;
    settings = await _happinessSettingsRepository.update(settings);
    _view?.notifySettingsImported(settings);

    //_view?.setInProgress(false);
  }

  /// Function used for scheduling all weekly notifications upon settings update
  Future<void> _scheduleNotifications() async {
    const dailyChannelId = 'daily_notification_channel_id';
    const dailyChannelName = 'Daily Notifications';
    const dailyTitle = 'Introspection Time';
    const dailyBody = 'Hey there, it is time to fill your introspection!';
    final dailyParts = (settings.timeOfTheDay ?? '16:00').split(':');
    final dailyTime = Time(int.parse(dailyParts[0]), int.parse(dailyParts[1]));

    const weeklyChannelId = 'weekly_notification_channel_id';
    const weeklyChannelName = 'weekly Notifications';
    const weeklyTitle = 'Retrospection Time';
    const weeklyBody = 'Hey there, it is time to fill your weekly review!';
    final weeklyParts =
    (settings.weeklyReviewTimeOfTheDay ?? '16:00').split(':');
    final weeklyTime =
    Time(int.parse(weeklyParts[0]), int.parse(weeklyParts[1]));
    final weeklyDay = settings.weeklyReviewDayOfWeek;

    // cancel all pending notifications
    await flutterLocalNotificationsPlugin.cancelAll();

    // replace the old cancelled notifications with the new daily notifications
    //based on the user settings
    if (settings.monday) {
      await _scheduleRepeatingNotification(
        id: 1,
        title: dailyTitle,
        body: dailyBody,
        dayOfWeek: Day.monday,
        time: dailyTime,
        channelId: dailyChannelId,
        channelName: dailyChannelName,
      );
    }
    if (settings.tuesday) {
      await _scheduleRepeatingNotification(
        id: 2,
        title: dailyTitle,
        body: dailyBody,
        dayOfWeek: Day.tuesday,
        time: dailyTime,
        channelId: dailyChannelId,
        channelName: dailyChannelName,
      );
    }
    if (settings.wednesday) {
      await _scheduleRepeatingNotification(
        id: 3,
        title: dailyTitle,
        body: dailyBody,
        dayOfWeek: Day.wednesday,
        time: dailyTime,
        channelId: dailyChannelId,
        channelName: dailyChannelName,
      );
    }
    if (settings.thursday) {
      await _scheduleRepeatingNotification(
        id: 4,
        title: dailyTitle,
        body: dailyBody,
        dayOfWeek: Day.thursday,
        time: dailyTime,
        channelId: dailyChannelId,
        channelName: dailyChannelName,
      );
    }
    if (settings.friday) {
      await _scheduleRepeatingNotification(
        id: 5,
        title: dailyTitle,
        body: dailyBody,
        dayOfWeek: Day.friday,
        time: dailyTime,
        channelId: dailyChannelId,
        channelName: dailyChannelName,
      );
    }
    if (settings.saturday) {
      await _scheduleRepeatingNotification(
        id: 6,
        title: dailyTitle,
        body: dailyBody,
        dayOfWeek: Day.saturday,
        time: dailyTime,
        channelId: dailyChannelId,
        channelName: dailyChannelName,
      );
    }
    if (settings.sunday) {
      await _scheduleRepeatingNotification(
        id: 7,
        title: dailyTitle,
        body: dailyBody,
        dayOfWeek: Day.sunday,
        time: dailyTime,
        channelId: dailyChannelId,
        channelName: dailyChannelName,
      );
    }

    // schedule weekly notification
    await _scheduleRepeatingNotification(
      id: 10,
      title: weeklyTitle,
      body: weeklyBody,
      dayOfWeek: weeklyDay,
      time: weeklyTime,
      channelId: weeklyChannelId,
      channelName: weeklyChannelName,
    );
  }

  /// Used for setting a repeating notification
  Future<void> _scheduleRepeatingNotification({
    required int id,
    required String title,
    required String body,
    required Day dayOfWeek,
    required Time time,
    required String channelId,
    required String channelName,
  }) async {
    final androidNotificationDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.max,
      priority: Priority.high,
      ongoing: false,
    );
    final notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    // Calculate the target DateTime
    final now = tz.TZDateTime.now(tz.local);

    var daysToAdd = (dayOfWeek.value - now.weekday + 6) % 7;
    if (daysToAdd == 0 &&
        (time.hour < now.hour ||
            (time.hour == now.hour && time.minute <= now.minute))) {
      daysToAdd += 7; // If the time has passed for today,
      // schedule for the same day next week
    }
    final targetDay = now.add(Duration(days: daysToAdd));
    final targetDateTime = tz.TZDateTime(
      tz.local,
      targetDay.year,
      targetDay.month,
      targetDay.day,
      time.hour,
      time.minute,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      targetDateTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      payload: targetDateTime.toString(),
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }
}
