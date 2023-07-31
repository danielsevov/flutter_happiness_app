// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/presentation/state_management/language_settings_state.dart';
import 'package:happiness_app/presentation/state_management/providers.dart';

void main() {

  test('LanguageSettingsState constructor should set currentLocale field test',
      () {
    const locale = Locale('en');
    final state = LanguageSettingsState(locale);
    expect(state.currentLocale, equals(locale));
  });

  group('languageSettingsProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should provide a LanguageSettingsState object', () {
      final state = container.read(languageSettingsStateProvider);
      expect(state, isA<LanguageSettingsState>());
    });

    test('should update the state when locale is changed', () {
      const expectedLocale = Locale('en');

      container.listen(
        languageSettingsStateProvider,
            (state, newState) {
          expect(newState.currentLocale, equals(expectedLocale));
        },
        fireImmediately: true,
      );

      container
          .read(languageSettingsStateProvider.notifier)
          .update((state) => LanguageSettingsState(expectedLocale));
    });
  });

}
