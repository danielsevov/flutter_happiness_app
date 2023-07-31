import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:happiness_app/helper.dart';

class IntrospectionChartDropdownTypeMenu extends StatelessWidget {
  const IntrospectionChartDropdownTypeMenu({
    required this.isBarChart, required this.onChanged,
    required this.constraints, super.key,});

  final bool isBarChart;
  final void Function(bool?) onChanged;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: DropdownButton<bool>(
        value: isBarChart,
        onChanged: onChanged,
        focusColor: Colors.transparent,
        dropdownColor: Theme.of(context).colorScheme.background,
        items: [
          DropdownMenuItem(
            value: true,
            child: Text(
              localizations.barChart,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: Helper.getSmallTextSize(constraints),),
            ),
          ),
          DropdownMenuItem(
            value: false,
            child: Text(
              localizations.lineChart,
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
