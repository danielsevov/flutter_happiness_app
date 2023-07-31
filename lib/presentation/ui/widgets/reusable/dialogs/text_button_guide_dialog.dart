import 'package:flutter/material.dart';
import 'package:happiness_app/helper.dart';

class TextButtonGuideDialog extends StatelessWidget {
  const TextButtonGuideDialog({
    required this.title,
    required this.bodyText,
    required this.constraints,
    required this.buttonLabel,
    required this.close,
    super.key,
  });

  final String buttonLabel;
  final String bodyText;
  final String title;
  final BoxConstraints constraints;
  final String close;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextButton(
        onPressed: () async {
          await showGeneralDialog(
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
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        Text(
                          bodyText,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: Helper.getNormalTextSize(constraints),
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
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: Helper.getNormalTextSize(
                                            constraints,),
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Text(
          buttonLabel,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontSize: Helper.getButtonTextSize(constraints),
              ),
        ),
      ),
    );
  }
}
