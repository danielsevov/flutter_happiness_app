import 'package:flutter/material.dart';

import 'package:happiness_app/helper.dart';

class CalendarEmptyDateMark extends StatelessWidget{
  const CalendarEmptyDateMark({required this.day,
    required this.constraints, required this.textColor,
    required this.backgroundColor, super.key, });

  final DateTime day;
  final BoxConstraints constraints;
  final Color textColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: TextStyle(
            color: textColor,
            fontSize: Helper.getSmallTextSize(constraints),
          ),
        ),
      ),
    );
  }
}
