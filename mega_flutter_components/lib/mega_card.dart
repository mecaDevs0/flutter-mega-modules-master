import 'package:flutter/material.dart';

class MegaCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final ShapeBorder? shape;
  final Color? color;
  final double? elevation;

  const MegaCard({
    required this.child,
    this.padding,
    this.margin,
    this.shape,
    this.color,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      shape: shape,
      color: color,
      elevation: elevation,
      surfaceTintColor: Colors.white,
      child: Container(
        padding: padding ?? const EdgeInsets.all(30),
        child: child,
      ),
    );
  }
}
