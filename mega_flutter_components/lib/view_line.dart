import 'package:flutter/material.dart';

class ViewLine extends StatelessWidget {
  final double height;
  final double? width;
  final Color? color;

  const ViewLine({
    this.height = 1,
    this.width,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: color ?? Theme.of(context).colorScheme.surface,
    );
  }
}
