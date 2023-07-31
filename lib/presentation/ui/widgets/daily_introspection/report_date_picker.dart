import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:happiness_app/helper.dart';

class CustomDatePicker extends StatelessWidget {
  final bool isDaily;
  final AppLocalizations localizations;
  final void Function(DateTime) onDateSelected;
  final BoxConstraints constraints;

  CustomDatePicker({required this.isDaily, required this.onDateSelected, required this.localizations, required this.constraints});

  Future<DateTime?> _selectDate(BuildContext context) {
    DateTime now = DateTime.now();

    // If not daily (i.e., weekly), adjust the initial date to be the nearest Monday
    if (!isDaily && now.weekday != DateTime.monday) {
      now = now.subtract(Duration(days: now.weekday - 1));
    }

    return showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000), // First date to be selected
      lastDate: DateTime.now(), // Last date to be selected
      selectableDayPredicate: (DateTime val) =>
      isDaily ? true : val.weekday == DateTime.monday, // If isDaily is false, allow only Mondays to be selected
    );
  }


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        DateTime? pickedDate = await _selectDate(context);
        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
      child: Text(localizations.selectDate,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.background,
          fontSize: Helper.getButtonTextSize(constraints),
        ),),
    );
  }
}
