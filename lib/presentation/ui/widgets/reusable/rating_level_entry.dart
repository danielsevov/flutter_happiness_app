// ignore_for_file: always_put_required_named_parameters_first, inference_failure_on_function_return_type, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:happiness_app/helper.dart';

/// Widget used nested in the weekly retrospection form,
/// which allows the user to fill in their rating for the week.
class RatingEntry extends StatelessWidget {
  const RatingEntry({
    super.key,
    required this.color,
    required this.icon,
    required this.onRatingUpdate,
    required this.constraints, required this.initialValue, required this.lowValueLabel, required this.highValueLabel,
  });
  final Color color;
  final IconData icon;
  final Function(double) onRatingUpdate;
  final BoxConstraints constraints;
  final double initialValue;
  final String lowValueLabel;
  final String highValueLabel;

  @override
  Widget build(BuildContext context) {
    final ratingValueNotifier = ValueNotifier<double>(initialValue);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                lowValueLabel,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.5),
                      fontSize: Helper.getSmallTextSize(constraints),
                    ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: RatingBar(
                  glowColor: color,
                  initialRating: initialValue,
                  itemCount: 10,
                  itemSize: Helper.getIconSize(constraints),
                  onRatingUpdate: (rating) {
                    ratingValueNotifier.value = rating;
                    onRatingUpdate(rating);
                  },
                  ratingWidget: RatingWidget(
                    full: ValueListenableBuilder<double>(
                      valueListenable: ratingValueNotifier,
                      builder: (context, value, child) => Icon(
                        icon,
                        color: color,
                      ),
                    ),
                    half: const SizedBox.shrink(),
                    empty: ValueListenableBuilder<double>(
                      valueListenable: ratingValueNotifier,
                      builder: (context, value, child) => Icon(
                        icon,
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                highValueLabel,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.5),
                      fontSize: Helper.getSmallTextSize(constraints),
                    ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
