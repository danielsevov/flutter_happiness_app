import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/ui/widgets/introspection_history/introspection_chart.dart';

class IntrospectionChartDropdownPeriodTypeMenu extends StatelessWidget {
  const IntrospectionChartDropdownPeriodTypeMenu({
    required this.groupedBy, required this.onChanged,
    required this.constraints, super.key,});

  final GroupBy groupedBy;
  final void Function(GroupBy?) onChanged;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            localizations.selectTypeOfPeriods,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: Helper.getSmallTextSize(constraints),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: DropdownButton<GroupBy>(
              value: groupedBy,
              onChanged: onChanged,
              focusColor: Colors.transparent,
              dropdownColor: Theme.of(context).colorScheme.background,
              items: [
                DropdownMenuItem(
                  value: GroupBy.day,
                  child: Text(
                      localizations.days,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: Helper.getSmallTextSize(constraints),),
                  ),
                ),
                DropdownMenuItem(
                  value: GroupBy.week,
                  child: Text(
                    localizations.weeks,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: Helper.getSmallTextSize(constraints),),
                  ),
                ),
                DropdownMenuItem(
                  value: GroupBy.month,
                  child: Text(
                    localizations.months,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: Helper.getSmallTextSize(constraints),),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
