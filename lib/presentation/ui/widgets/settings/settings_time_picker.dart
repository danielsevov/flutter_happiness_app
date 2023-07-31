import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:happiness_app/helper.dart';

class SettingsTimePicker extends StatefulWidget {
  const SettingsTimePicker({
    required this.onChanged,
    required this.constraints,
    required this.initialTime,
    required this.type,
    super.key,
  });

  final void Function(String timeOfDay) onChanged;
  final BoxConstraints constraints;
  final String initialTime;
  final String type;

  @override
  State<SettingsTimePicker> createState() => _SettingsTimePickerState();
}

class _SettingsTimePickerState extends State<SettingsTimePicker> {
  late TimeOfDay _selectedTime;

  TimeOfDay parseTimeOfDay(String timeString) {
    final timeComponents = timeString.split(':');
    final hours = int.parse(timeComponents[0]);
    final minutes = int.parse(timeComponents[1]);
    return TimeOfDay(hour: hours, minute: minutes);
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final hours = timeOfDay.hour.toString().padLeft(2, '0');
    final minutes = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  Future<void> _pickTime() async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (newTime != null) {
      setState(() {
        _selectedTime = newTime;
        widget.onChanged(formatTimeOfDay(_selectedTime));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    _selectedTime = parseTimeOfDay(widget.initialTime);

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.spaceEvenly,
      children: [
        Text(
          localizations
              .notifyMeAtTime(formatTimeOfDay(_selectedTime)),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: Helper.getNormalTextSize(widget.constraints),
              ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: FloatingActionButton(
            heroTag: widget.type,
            onPressed: _pickTime,
            backgroundColor: Theme.of(context).colorScheme.primary,
            mini: true,
            child: Icon(
              CupertinoIcons.clock,
              color: Theme.of(context).colorScheme.background,
            ),
          ),
        )
      ],
    );
  }
}
