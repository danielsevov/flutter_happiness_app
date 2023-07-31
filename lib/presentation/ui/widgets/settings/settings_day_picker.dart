import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:happiness_app/helper.dart';

class SettingsDayPicker extends StatefulWidget {
  const SettingsDayPicker({
    required this.onChanged,
    required this.initialDay,
    required this.constraints,
    super.key,
  });

  final void Function(Day) onChanged;
  final Day initialDay;
  final BoxConstraints constraints;

  @override
  SettingsDayPickerState createState() => SettingsDayPickerState();
}

class SettingsDayPickerState extends State<SettingsDayPicker> {
  late Day selectedDay;

  @override
  void initState() {
    super.initState();
    selectedDay = widget.initialDay;
  }

  @override
  Widget build(BuildContext context) {
    final daysOfWeek = [
      Day.monday,
      Day.tuesday,
      Day.wednesday,
      Day.thursday,
      Day.friday,
      Day.saturday,
      Day.sunday,
    ];
    final dayLocalization = {
      Day.monday: AppLocalizations.of(context)!.monday,
      Day.tuesday: AppLocalizations.of(context)!.tuesday,
      Day.wednesday: AppLocalizations.of(context)!.wednesday,
      Day.thursday: AppLocalizations.of(context)!.thursday,
      Day.friday: AppLocalizations.of(context)!.friday,
      Day.saturday: AppLocalizations.of(context)!.saturday,
      Day.sunday: AppLocalizations.of(context)!.sunday,
    };

    final crossAxisCount = widget.constraints.maxWidth > 800 ? 7 : 4;
    const childAspectRatio = 2.5;


    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: widget.constraints.maxWidth > 800
            ? 800
            : widget.constraints.maxWidth,
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          children: daysOfWeek.map((Day day) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDay = day;
                });
                widget.onChanged(day);
              },
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: selectedDay == day
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.5),
                  ),
                ),
                child: Center(
                  child: Text(
                    dayLocalization[day]!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: selectedDay == day
                              ? Theme.of(context).colorScheme.background
                              : Theme.of(context).colorScheme.onBackground,
                          fontSize: Helper.getSmallTextSize(widget.constraints),
                        ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
