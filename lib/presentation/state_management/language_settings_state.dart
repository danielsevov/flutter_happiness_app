// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

import 'dart:ui';

/// LanguageSettingsState object is a holder of the app locale settings, which are shared among multiple pages and widgets.
/// It is used in combination with the Riverpod package to allow widgets to look up the app state
/// object in the widget tree and to access it when needed.
class LanguageSettingsState {

  LanguageSettingsState(this.currentLocale);
  final Locale currentLocale;
}
