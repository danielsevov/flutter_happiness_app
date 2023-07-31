import 'package:flutter/material.dart';
import 'package:happiness_app/helper.dart';

class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    required this.onChanged,
    required this.constraints,
    required this.value,
    required this.title,
    super.key,
  });

  final void Function(bool onChanged) onChanged;
  final BoxConstraints constraints;
  final bool value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: constraints.maxWidth > 500 ? 500 : constraints.maxWidth,
        child: SwitchListTile(
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: Helper.getNormalTextSize(constraints),
                ),
          ),
          value: value,
          activeColor: Theme.of(context).colorScheme.primary,
          onChanged: onChanged,
        ),);
  }
}
