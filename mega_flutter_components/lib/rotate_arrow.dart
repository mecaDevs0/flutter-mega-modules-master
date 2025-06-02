import 'dart:math';

import 'package:flutter/material.dart';

class RotateArrow extends StatefulWidget {
  final Function() onPress;
  final Widget arrowIcon;
  const RotateArrow({
    Key? key,
    required this.onPress,
    required this.arrowIcon,
  }) : super(key: key);

  @override
  _RotateArrowState createState() => _RotateArrowState();
}

class _RotateArrowState extends State<RotateArrow>
    with TickerProviderStateMixin {
  late Animation _arrowAnimation;
  late AnimationController _arrowAnimationController;

  @override
  void initState() {
    super.initState();
    _arrowAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _arrowAnimation =
        Tween(begin: 0.0, end: pi).animate(_arrowAnimationController);
  }

  @override
  void dispose() {
    _arrowAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _arrowAnimationController,
      builder: (context, child) => Transform.rotate(
        angle: _arrowAnimation.value,
        child: GestureDetector(
            onTap: () {
              widget.onPress();
              _arrowAnimationController.isCompleted
                  ? _arrowAnimationController.reverse()
                  : _arrowAnimationController.forward();
            },
            child: widget.arrowIcon),
      ),
    );
  }
}
