import 'package:flutter/material.dart';

import 'package:happiness_app/helper.dart';
import 'package:happiness_app/presentation/ui/widgets/daily_introspection/base_report_body.dart';

class CalendarReportDateMark extends StatelessWidget {
  const CalendarReportDateMark({required this.constraints,
    required this.d, required this.day, required this.widgets,
    required this.backgroundColor, super.key, });

  final BoxConstraints constraints;
  final DateTime d;
  final DateTime day;
  final Map<DateTime, BaseReportBody> widgets;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel: MaterialLocalizations.of(context)
              .modalBarrierDismissLabel,
          barrierColor: Colors.black45,
          transitionDuration: const Duration(milliseconds: 300),
          transitionBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            // transition to use
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          pageBuilder: (BuildContext buildContext,
              Animation<double> animation, Animation<double> secondaryAnimation) {
            return SimpleDialog(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Helper.formatter.format(d),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground,
                          fontSize: Helper.getSmallHeadingSize(
                            constraints,),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: widgets[d] ?? const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${day.day}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.background,
                fontSize: Helper.getSmallTextSize(constraints),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
