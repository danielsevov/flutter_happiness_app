// ignore_for_file: always_put_required_named_parameters_first, inference_failure_on_function_return_type, lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/ui/widgets/reusable/dialogs/custom_tooltip_icon.dart';

/// Widget used nested in the daily introspection form,
/// which allows the user to fill in their feeling level for the day.
class FeelingLevelEntry extends StatelessWidget {
  const FeelingLevelEntry({
    super.key,
    required this.feeling,
    required this.color,
    required this.icon,
    required this.onRatingUpdate,
    required this.constraints,
    required this.initialValue,
    required this.hint,
    required this.lowValueLabel,
    required this.highValueLabel,
  });
  final String feeling;
  final Color color;
  final IconData icon;
  final Function(double) onRatingUpdate;
  final BoxConstraints constraints;
  final double initialValue;
  final String hint;
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
            mainAxisAlignment: constraints.maxWidth > 800 ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CustomTooltipIcon(icon: icon, message: hint, constraints: constraints, color: color),
              ),
              Text(
                feeling,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: Helper.getNormalTextSize(constraints),
                    ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: constraints.maxWidth / 8,
                child: Center(
                  child: FittedBox(
                    child: Text(
                      lowValueLabel,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.5),
                            fontSize: Helper.getSmallTextSize(constraints),
                          ),
                    ),
                  ),
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
                        Icons.circle,
                        color: color,
                      ),
                    ),
                    half: const SizedBox.shrink(),
                    empty: ValueListenableBuilder<double>(
                      valueListenable: ratingValueNotifier,
                      builder: (context, value, child) => Icon(
                        Icons.circle_outlined,
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: constraints.maxWidth / 8,
                child: Center(
                  child: FittedBox(
                    child: Text(
                      highValueLabel,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.5),
                            fontSize: Helper.getSmallTextSize(constraints),
                          ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
