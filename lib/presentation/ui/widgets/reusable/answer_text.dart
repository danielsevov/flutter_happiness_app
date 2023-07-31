// ignore_for_file: lines_longer_than_80_chars, always_put_required_named_parameters_first, avoid_multiple_declarations_per_line

import 'package:flutter/material.dart';
import 'package:happiness_app/helper.dart';

/// Reusable introspection answer text widget
class AnswerText extends StatelessWidget {
  const AnswerText(
      {super.key,
      required this.icon,
      required this.question,
      required this.answer,
      required this.constraints,});
  final IconData icon;
  final String question, answer;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  icon,
                  size: Helper.getIconSize(constraints),
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  question,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.w700,
                      fontSize: Helper.getNormalTextSize(constraints),),
                ),
              ),
              Text(
                answer,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w400,
                    fontSize: Helper.getNormalTextSize(constraints),),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
