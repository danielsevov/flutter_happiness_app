import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:happiness_app/helper.dart';

class IntrospectionChartDropdownPeriodMenu extends StatelessWidget {
  const IntrospectionChartDropdownPeriodMenu({
    required this.numberOfWeeksToShow, required this.onChanged,
    required this.constraints, super.key,});

  final int numberOfWeeksToShow;
  final void Function(int?) onChanged;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SizedBox(
      height: 52.5,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Text(
              localizations.selectNumberOfPeriods,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: Helper.getSmallTextSize(constraints),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            DropdownButton<int>(
              value: numberOfWeeksToShow,
              onChanged: onChanged,
              focusColor: Colors.transparent,
              dropdownColor: Theme.of(context).colorScheme.background,
              items: [
                DropdownMenuItem(
                  value: 4,
                  child: Text(
                    localizations.fourWeeks,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: Helper.getSmallTextSize(constraints),),
                  ),
                ),
                DropdownMenuItem(
                  value: 8,
                  child: Text(
                    localizations.eightWeeks,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: Helper.getSmallTextSize(constraints),),
                  ),
                ),
                DropdownMenuItem(
                  value: 12,
                  child: Text(
                    localizations.twelveWeeks,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: Helper.getSmallTextSize(constraints),),
                  ),
                ),
                DropdownMenuItem(
                  value: 24,
                  child: Text(
                    localizations.twentyFourWeeks,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: Helper.getSmallTextSize(constraints),),
                  ),
                ),
                DropdownMenuItem(
                  value: 52,
                  child: Text(
                    localizations.fiftyTwoWeeks,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: Helper.getSmallTextSize(constraints),),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
