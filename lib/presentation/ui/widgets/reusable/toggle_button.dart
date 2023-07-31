import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:happiness_app/helper.dart';

class CustomToggleButton extends StatelessWidget {
  const CustomToggleButton({
    required this.changeReportType,
    required this.fetchDaily,
    required this.constraints,
    super.key,
  });
  final void Function(int? type) changeReportType;
  final bool fetchDaily;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      color: Theme.of(context).colorScheme.background,
      borderColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
      selectedBorderColor: Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.circular(10),
      isSelected: [fetchDaily, !fetchDaily],
      onPressed: changeReportType,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            AppLocalizations.of(context)!.dailyIntrospection,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: Helper.getNormalTextSize(constraints),
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            AppLocalizations.of(context)!.weeklyRetrospection,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: Helper.getNormalTextSize(constraints),
                ),
          ),
        ),
      ],
    );
  }
}
