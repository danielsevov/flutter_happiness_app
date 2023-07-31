import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happiness_app/helper.dart';

/// A pop-up widget to be placed next to a question in the introspection/retrospection
/// form to give help and guidance to the user while filling in a question.
class IconButtonGuideDialog extends StatelessWidget {
  const IconButtonGuideDialog({
    required this.title,
    required this.guideline,
    required this.constraints,
  required this.close, super.key,
  });

  final String guideline;
  final String title;
  final BoxConstraints constraints;
  final String close;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showGeneralDialog(
          context: context,
          barrierDismissible: true, // indicate whether clicking outside the dialog will close it
          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Colors.black45, // color of the modal barrier
          transitionDuration: const Duration(milliseconds: 300), // transition duration
          pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
            // dialog to show
            return  SimpleDialog(
              backgroundColor: Theme.of(context).colorScheme.background,
              title: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: Helper.getSmallHeadingSize(constraints),
                  ),
                ),
              ),
              children: [
                SizedBox(
                  width: constraints.maxWidth > 800
                      ? constraints.maxWidth / 2
                      : constraints.maxWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Text(
                      guideline,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: Helper.getNormalTextSize(constraints),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          close,
                          style: Theme.of(context)
                              .textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: Helper.getNormalTextSize(constraints),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
          transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
            // transition to use
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
        );
      },
      icon: Icon(
        CupertinoIcons.info,
        color: Theme.of(context).colorScheme.primary,
        size: Helper.getIconSize(constraints),
      ),
    );
  }
}
