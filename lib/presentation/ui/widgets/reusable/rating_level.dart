// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:happiness_app/helper.dart';

/// Reusable introspection rating entry answer widget
class RatingLevel extends StatelessWidget {
  const RatingLevel(
      {super.key,
      required this.icon,
      required this.color,
      required this.constraints,
      required this.ratingLevel,
      required this.ratingTitle,});
  final IconData icon;
  final Color color;
  final BoxConstraints constraints;
  final String ratingTitle;
  final int ratingLevel;

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
              ratingTitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.w700,
                  fontSize: Helper.getNormalTextSize(constraints),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Text(
              ratingLevel.toString(),
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
