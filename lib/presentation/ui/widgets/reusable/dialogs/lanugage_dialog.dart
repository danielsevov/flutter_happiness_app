// ignore_for_file: always_put_required_named_parameters_first, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/dialogs/language_dialog_tile.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog(
      {super.key,
      required this.constraints,
      required this.currentLocale, required this.onChanged,});
  final BoxConstraints constraints;
  final Locale currentLocale;
  final void Function(String locale) onChanged;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
          width: 2,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Text(
        localizations.selectLanguage,
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize:
              Helper.getSmallHeadingSize(constraints),
            ),
      ),
      children: [
        // Add a list tile for english language option
        LanguageDialogTile(
          currentLocaleLanguageCode: currentLocale.languageCode,
          language: localizations.english,
          assetPath: 'icons/flags/png/gb.png',
          onTap: () async {
            Navigator.pop(context);

            onChanged('en');
          },
          languageCode: 'en',
          constraints: constraints,
        ),

        // Add a list tile for dutch language option
        LanguageDialogTile(
          currentLocaleLanguageCode: currentLocale.languageCode,
          language: localizations.dutch,
          assetPath: 'icons/flags/png/nl.png',
          onTap: () async {
            Navigator.pop(context);

            onChanged('nl');
          },
          languageCode: 'nl',
          constraints: constraints,
        ),

        // Add a list tile for bulgarian language option
        LanguageDialogTile(
          currentLocaleLanguageCode: currentLocale.languageCode,
          language: localizations.bulgarian,
          assetPath: 'icons/flags/png/bg.png',
          onTap: () async {
            Navigator.pop(context);

            onChanged('bg');
          },
          languageCode: 'bg',
          constraints: constraints,
        ),
      ],
    );
  }
}
