import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mega_flutter_base/utils/formats.dart';

import 'animated_column.dart';
import 'expandable_item.dart';
import 'slidable_item.dart';

class NotificationItem extends StatelessWidget {
  final String title;
  final String content;
  final int dateCreated;
  final int? dateRead;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final Function onRemove;

  NotificationItem({
    Key? key,
    required this.title,
    required this.content,
    required this.dateCreated,
    this.dateRead,
    this.titleStyle,
    this.descriptionStyle,
    required this.onRemove,
  })  : assert(title.isNotEmpty),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: SlidableItem(
        secondaryActions: [
          SlidableAction(
            onPressed: (_) => this.onRemove(),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.red,
            icon: Icons.delete,
            label: 'Remover',
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300]!,
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: AnimatedColumn(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        title,
                        style: titleStyle ?? theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 7),
                      ExpandableItem(
                        topPadding: 0,
                        description: content,
                        descriptionStyle: descriptionStyle,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Image.asset(
                            'assets/ic_clock.png',
                            package: 'mega_flutter_components',
                            height: 16,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            Formats.formatDate(
                              context,
                              format: Formats.notificationDateFormat.pattern,
                              value: DateTime.fromMillisecondsSinceEpoch(
                                this.dateCreated * 1000,
                              ),
                            ),
                            style: theme.textTheme.bodySmall,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Visibility(
                    visible: dateRead == null,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: CircleAvatar(
                          backgroundColor: theme.primaryColor, radius: 4),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
