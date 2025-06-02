import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'cached_image.dart';

class CardRow extends StatelessWidget {
  final String brand;
  final String card;
  final bool selected;
  final EdgeInsets padding;
  final Function() onTap;

  const CardRow({
    required this.brand,
    required this.card,
    required this.onTap,
    this.selected = false,
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            CachedImage(
              brand,
              height: 20,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                card,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(width: 15),
            Visibility(
              visible: selected,
              child: FaIcon(
                FontAwesomeIcons.circleCheck,
                size: 20,
                color: Theme.of(context).primaryColorDark,
              ),
            )
          ],
        ),
      ),
    );
  }
}
