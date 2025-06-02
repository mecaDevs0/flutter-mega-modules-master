import 'package:flutter/material.dart';

class MegaOutlinedButton extends StatelessWidget {
  final String label;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? labelColor;
  final double radius;
  final double borderWidth;
  final Function()? onTap;
  final Function()? onLongTap;

  MegaOutlinedButton(
      {required this.label,
      this.leftIcon,
      this.rightIcon,
      this.onTap,
      this.backgroundColor,
      this.borderColor,
      this.labelColor,
      this.radius = 5,
      this.borderWidth = 1,
      this.onLongTap})
      : assert(label.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongTap,
      child: Container(
        height: Theme.of(context).buttonTheme.height,
        decoration: ShapeDecoration(
          // color: backgroundColor ?? Theme.of(context).backgroundColor,
          shape: Theme.of(context).buttonTheme.shape,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor ?? Theme.of(context).primaryColor,
              width: borderWidth,
            ),
          ),
          child: Padding(
            padding: Theme.of(context).buttonTheme.padding,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  leftIcon ?? Container(),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: labelColor ??
                              Theme.of(context).textTheme.labelLarge!.color,
                        ),
                  ),
                  rightIcon ?? Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
