import 'package:flutter/cupertino.dart';

class SingleColor extends StatelessWidget {
  final Widget child;
  final Color color;

  SingleColor({Key? key, required this.child, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(color, BlendMode.srcATop),
      child: child,
    );
  }
}