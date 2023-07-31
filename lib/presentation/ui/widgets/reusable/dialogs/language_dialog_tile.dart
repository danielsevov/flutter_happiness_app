// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, avoid_multiple_declarations_per_line, inference_failure_on_function_return_type

import 'package:flutter/material.dart';
import 'package:happiness_app/helper.dart';

class LanguageDialogTile extends StatelessWidget {
  const LanguageDialogTile({
    super.key,
    required this.currentLocaleLanguageCode,
    required this.language,
    required this.assetPath,
    required this.onTap,
    required this.languageCode,
    required this.constraints,
  });
  final String currentLocaleLanguageCode, languageCode, language, assetPath;
  final BoxConstraints constraints;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // Add the flag of the language next to the name
          const SizedBox(),
          Text(
            language,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: Helper.getNormalTextSize(constraints),),
          ),
          const SizedBox(),
          Image.asset(
            assetPath,
            package: 'country_icons',
            width: Helper.getIconSize(constraints),
          ),
        ],
      ),
      onTap: onTap,
      leading: Icon(
        Icons.language,
        size: Helper.getIconSize(constraints),
        // Highlight the current language with a blue color
        color: currentLocaleLanguageCode == languageCode
            ? Theme.of(context).colorScheme.primary
            : null,
      ),
    );
  }
}
