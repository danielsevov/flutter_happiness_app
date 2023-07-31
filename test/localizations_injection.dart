// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class LocalizationsInj extends StatelessWidget {
  const LocalizationsInj({super.key, required this.child, required this.locale});
  final Widget child;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        locale,
      ],
      home: child,
    );
  }
}
