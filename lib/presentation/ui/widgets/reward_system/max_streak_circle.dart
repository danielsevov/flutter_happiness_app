import 'package:flutter/material.dart';
import 'package:happiness_app/helper.dart';

class MaxStreakCircle extends StatelessWidget {
  final int streak;
  final bool isWeekly;
  final BoxConstraints constraints;

  MaxStreakCircle({required this.streak, required this.constraints, required this.isWeekly});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Helper.getDrawerSize(constraints) / 8, // or any size you want
      height: Helper.getDrawerSize(constraints) / 8, // or any size you want
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              width: Helper.getDrawerSize(constraints) / 9,
              height: Helper.getDrawerSize(constraints) / 9,
              child: CircularProgressIndicator(
                value: 1, // calculate the percent fill
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 1.0,
              ),
            ),
          ),
          Center(
            child: Text(
              '$streak' + (!isWeekly ? 'd' : 'w'),
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(
                  fontSize: Helper.getSmallTextSize(constraints),
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.background),
            ),
          ),
        ],
      ),
    );
  }
}