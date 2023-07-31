// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, avoid_multiple_declarations_per_line, inference_failure_on_function_return_type

import 'package:flutter/material.dart';
import 'package:happiness_app/helper.dart';

/// Custom AlertDialog widget with confirm and cancel buttons.
class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    required this.bodyText,
    required this.confirm,
    required this.cancel,
    required this.constraints,
  });
  final String title, bodyText;
  final Function() confirm, cancel;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Text(
        title,
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize:
              Helper.getSmallHeadingSize(constraints),
            ),
      ),
      content: SingleChildScrollView(
        child: Text(
          bodyText,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize:
              Helper.getNormalTextSize(constraints),),
        ),
      ),
      actions: [
        IconButton(
          onPressed: confirm,
          icon: Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
            size: Helper.getIconSize(constraints),
          ),
        ),
        IconButton(
          onPressed: cancel,
          icon: Icon(
            Icons.cancel,
            color: Theme.of(context).colorScheme.onBackground,
            size: Helper.getIconSize(constraints),
          ),
        )
      ],
    );
  }
}
