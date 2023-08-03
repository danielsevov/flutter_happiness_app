import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:happiness_app/app_colors.dart';
import 'package:happiness_app/presentation/state_management/providers.dart';
import 'package:happiness_app/presentation/ui/pages/login_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

bool providersInitialized = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  if (!kIsWeb && !Platform.isMacOS) {
    await requestPermissions();
  }

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Amsterdam'));

  await initializeNotifications();

  runApp(const ProviderScope(child: MyApp()));
}

Future<void> requestPermissions() async {
  final internetStatus = await Permission.sensors.status;
  if (!internetStatus.isGranted) {
    await Permission.sensors.request();
  }

  final storageStatus = await Permission.storage.status;
  if (!storageStatus.isGranted) {
    await Permission.storage.request();
  }

  final notificationStatus = await Permission.notification.status;
  if (!notificationStatus.isGranted) {
    await Permission.notification.request();
  }
}

Future<void> initializeNotifications() async {
  const initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');
  const initializationSettingsIOS = IOSInitializationSettings();
  const initializationSettingsMacOS = MacOSInitializationSettings();
  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
    macOS: initializationSettingsMacOS,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef reff, Widget? child) {

        return MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('nl'), // Dutch
            Locale('bg'), // Bulgarian
          ],
          locale: reff
              .watch(
                  languageSettingsStateProvider)
              .currentLocale,
          theme: ThemeData(
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: AppColors.primaryBlue.withOpacity(0.1),
              prefixIconColor: AppColors.primaryBlue,
              errorStyle: const TextStyle(color: Colors.deepOrange),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: AppColors.primaryBlue,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.deepOrange),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.deepOrange),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryBlue.withOpacity(0.5),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.kabisaBlack.withOpacity(0.3),
                  ),
            ),
            colorScheme: const ColorScheme(
              primary: AppColors.primaryBlue,
              secondary: AppColors.secondaryBlue,
              background: AppColors.kabisaWhite,
              surface: AppColors.kabisaWhite,
              error: Colors.deepOrange,
              onPrimary: AppColors.kabisaWhite,
              onSecondary: AppColors.kabisaBlack,
              onBackground: AppColors.kabisaBlack,
              brightness: Brightness.light,
              onError: AppColors.kabisaWhite,
              onSurface: AppColors.kabisaBlack,
            ),
            textTheme: const TextTheme(
              displayLarge: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
              bodyLarge: TextStyle(
                fontFamily: 'Poppins',
              ),
            ),
          ),
          home: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: LogInPage(
              odooTokenRepository:
                  reff.watch(odooRepoProvider),
              initializeDatasource: reff.watch(initOdooMethodProvider),
            ),
          ),
        );
      },
    );
  }
}
