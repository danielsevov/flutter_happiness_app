import 'package:flutter/material.dart';
import 'package:happiness_app/helper.dart';

/// Custom drawer body item widget used for navigation,
/// placed on the home page drawer.
class CustomDrawerBodyItem extends StatelessWidget {
  const CustomDrawerBodyItem({
    required this.function,
    required this.title,
    required this.icon,
    required this.tileColor,
    required this.constraints,
    super.key,
  });
  final void Function() function;
  final BoxConstraints constraints;
  final String title;
  final IconData icon;
  final Color tileColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2, top: 2),
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.secondary,
        shape: const RoundedRectangleBorder(),
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(icon,
                color: Theme.of(context).colorScheme.background,
                size: Helper.getIconSize(constraints),),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize:
                Helper.getSmallHeadingSize(constraints),
                color: Theme.of(context).colorScheme.background,
              ),
            )
          ],
        ),
        onTap: function,
      ),
    );
  }
}
