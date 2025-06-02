import 'package:flutter/material.dart';

class MegaFilledButton extends StatelessWidget {
  final String? label;
  final Widget? labelWidget;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final Color? color;
  final Color? labelColor;
  final Function()? onTap;
  final Function()? onLongTap;
  final Function()? onDoubleTap;
  final bool isLoading;

  const MegaFilledButton({
    this.label,
    this.labelWidget,
    this.leftIcon,
    this.rightIcon,
    this.onTap,
    this.color,
    this.labelColor,
    this.onLongTap,
    this.onDoubleTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      onLongPress: onLongTap ?? () {},
      onDoubleTap: onDoubleTap ?? () {},
      child: Container(
        height: Theme.of(context).buttonTheme.height,
        decoration: ShapeDecoration(
          shape: Theme.of(context).buttonTheme.shape,
          color: color ?? Theme.of(context).primaryColor,
        ),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    labelColor ?? Theme.of(context).textTheme.labelLarge!.color,
                  ),
                ),
              )
            : _label(context),
      ),
    );
  }

  Widget _label(BuildContext context) {
    if (label != null && label!.isNotEmpty) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            leftIcon ?? Container(),
            Text(
              label ?? '',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: labelColor ??
                      Theme.of(context).textTheme.labelLarge!.color),
            ),
            rightIcon ?? Container(),
          ],
        ),
      );
    }

    return labelWidget ?? Container();
  }
}
