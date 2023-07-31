import 'package:flutter/material.dart';
import 'package:happiness_app/helper.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class CustomTooltipIcon extends StatelessWidget {
  const CustomTooltipIcon({
    required this.icon,
    required this.message,
    required this.constraints,
    required this.color,
    super.key,
  });

  final IconData icon;
  final Color color;
  final String message;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return JustTheTooltip(
      triggerMode: TooltipTriggerMode.tap,
      content: SizedBox(
        width: constraints.maxWidth > 600 ? 600 : constraints.maxWidth,
        child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: Helper.getNormalTextSize(constraints),
          ),
        ),
    ),
      ),
    backgroundColor: Theme.of(context).colorScheme.background,
      child: Icon(icon, color: color,
      size: Helper.getIconSize(constraints),),);
  }
}
