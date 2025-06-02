import 'package:flutter/material.dart';

class ExpandedItem extends StatefulWidget {
  final Widget child;
  final bool isExpanded;
  const ExpandedItem({
    this.isExpanded = false,
    required this.child,
  });

  @override
  _ExpandedItemState createState() => _ExpandedItemState();
}

class _ExpandedItemState extends State<ExpandedItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    );
    _playAnimation();
  }

  void _playAnimation() {
    if (widget.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandedItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    _playAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        axisAlignment: 1.0, sizeFactor: _animation, child: widget.child);
  }
}
