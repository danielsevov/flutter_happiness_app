import 'dart:io';

import 'package:flutter/material.dart';
import 'package:happiness_app/helper.dart';

/// Custom drawer widget used for navigation, placed on the home page view.
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    required this.constraints,
    required this.widgets,
    super.key,
  });

  final BoxConstraints constraints;
  final List<Widget> widgets;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      width:
      Helper.getDrawerSize(constraints),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: constraints.maxHeight> 500 && !Platform.isMacOS  ?
          const Radius.circular(180) : Radius.circular(5),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: widgets,
        ),
      ),
    );
  }
}
