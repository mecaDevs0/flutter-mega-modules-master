import 'package:flutter/material.dart';

class TextInfo extends StatelessWidget {
  final String label;
  final String info;
  final bool expanded;
  final Color color;
  final FontWeight fontWeight;

  const TextInfo({
    required this.label,
    required this.info,
    this.expanded = false,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    if (expanded) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: textTheme.bodyMedium!.copyWith(
                  color: color,
                  fontWeight: fontWeight,
                ),
              ),
            ),
            Text(
              info,
              style: textTheme.bodyMedium!.copyWith(
                color: color,
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: RichText(
          text: TextSpan(
            text: '$label:',
            style: textTheme.titleMedium!.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' $info',
                style: textTheme.titleMedium!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
