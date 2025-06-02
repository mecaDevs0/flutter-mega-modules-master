import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final double size;
  final TextAlign align;
  final TextStyle? textStyle;
  final Color? iconColor;
  final double space;

  const IconRow({
    required this.icon,
    required this.label,
    this.size = 12,
    this.iconColor,
    this.textStyle,
    this.space = 0,
    this.align = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: FaIcon(
              icon,
              color: iconColor ??
                  textStyle?.color ??
                  Theme.of(context).primaryColorDark,
              size: size,
            ),
          ),
          SizedBox(width: space),
          Flexible(
            child: Text(
              label,
              style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
              maxLines: 3,
              textAlign: align,
            ),
          )
        ],
      ),
    );
  }
}
