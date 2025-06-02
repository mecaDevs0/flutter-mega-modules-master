import 'package:flutter/material.dart';
import 'package:megaleios_flutter_localization/megaleios_flutter_localization.dart';

class ExpandableItem extends StatefulWidget {
  final String? title;
  final String description;
  final TextStyle? descriptionStyle;
  final String? expandLabel;
  final double topPadding;
  final int lines;

  const ExpandableItem({
    this.title,
    required this.description,
    this.descriptionStyle,
    this.expandLabel,
    this.lines = 3,
    this.topPadding = 30,
  });

  @override
  _ExpandableItemState createState() => _ExpandableItemState();
}

class _ExpandableItemState extends State<ExpandableItem> {
  bool showAllDescription = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.topPadding),
      child: LayoutBuilder(
        builder: (_, size) {
          final span = TextSpan(
            text: widget.description,
            style: widget.descriptionStyle ??
                Theme.of(context).textTheme.bodyMedium,
          );
          final tp = TextPainter(
              text: span,
              textDirection: TextDirection.ltr,
              maxLines: widget.lines);
          tp.layout(maxWidth: size.maxWidth);

          final overflow = tp.didExceedMaxLines;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Visibility(
                visible: widget.title != null,
                child: Text(
                  widget.title ?? '',
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.description,
                style: widget.descriptionStyle ??
                    Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: showAllDescription ? 100 : widget.lines,
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: overflow && !showAllDescription,
                child: GestureDetector(
                  onTap: () => setState(() {
                    showAllDescription = !showAllDescription;
                  }),
                  child: Text(
                    widget.expandLabel ??
                        MegaleiosLocalizations.of(context)!
                            .translate('see_all'),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
