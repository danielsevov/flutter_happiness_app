
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/dialogs/language_dialog_tile.dart';

import '../../localizations_injection.dart';

void main() {

  testWidgets('should display English language', (WidgetTester tester) async {
    const currentLocaleLanguageCode = 'en';
    const language = 'English';
    const assetPath = 'icons/flags/png/us.png';
    const languageCode = 'en';

    await tester.pumpWidget(LocalizationsInj(
        locale: const Locale('en'),
        child: Scaffold(
            body: Center(
              child: SingleChildScrollView(
                  child: LanguageDialogTile(
                    currentLocaleLanguageCode: currentLocaleLanguageCode,
                    language: language,
                    assetPath: assetPath,
                    onTap: () { },
                    languageCode: languageCode,
                    constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
                  ),),
            ),),),);

    await tester.pumpAndSettle();

    expect(find.text(language), findsOneWidget);
  });

  testWidgets('test onTap()', (WidgetTester tester) async {
    const currentLocaleLanguageCode = 'en';
    const language = 'English';
    const assetPath = 'icons/flags/png/us.png';
    const languageCode = 'en';
    var tapped = false;

    await tester.pumpWidget(LocalizationsInj(
        locale: const Locale('en'),
        child: Scaffold(
            body: Center(
              child: SingleChildScrollView(
                  child: LanguageDialogTile(
                    currentLocaleLanguageCode: currentLocaleLanguageCode,
                    language: language,
                    assetPath: assetPath,
                    onTap: () {
                      tapped = true;
                    },
                    languageCode: languageCode,
                    constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
                  ),),
            ),),),);

    await tester.pumpAndSettle();

    await tester.tap(find.text(language));

    expect(tapped, true);
  });
}
