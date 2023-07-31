// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:happiness_app/helper.dart';

/// Reusable introspection feeling entry answer widget
class FeelingLevel extends StatelessWidget {
  const FeelingLevel(
      {super.key,
      required this.icon,
      required this.color,
      required this.constraints,
      required this.feelingLevel,
      required this.feeling,});
  final IconData icon;
  final Color color;
  final BoxConstraints constraints;
  final String feeling;
  final int feelingLevel;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: Helper.getIconSize(constraints),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              localizations.feelingLevel(feeling),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.w700,
                  fontSize: Helper.getNormalTextSize(constraints),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Text(
              feelingLevel.toString(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: color,
                  fontSize: Helper.getBigHeadingSize(constraints),
                  fontWeight: FontWeight.w700,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              localizations.outOfTen,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: Helper.getSmallTextSize(constraints),),
            ),
          ),
        ],
      ),
    );
  }
}
