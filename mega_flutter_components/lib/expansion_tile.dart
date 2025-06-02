import 'package:flutter/material.dart';

class MegaExpansionTile extends StatelessWidget {
  final String title;
  final List<Widget> contents;

  const MegaExpansionTile({
    required this.title,
    required this.contents,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Theme(
      data: theme.copyWith(
        dividerColor: Colors.grey[400],
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: theme.unselectedWidgetColor)
            .copyWith(surface: Colors.white),
      ),
      child: Column(
        children: [
          ExpansionTile(
            key: const PageStorageKey<Map>({'dasds': 'dasda'}),
            backgroundColor: Colors.white,
            title: Text(
              title,
              style: textTheme.bodyMedium,
            ),
            children: contents.map((content) => _ContentItem(content)).toList(),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}

class _ContentItem extends StatelessWidget {
  final Widget content;

  const _ContentItem(this.content);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 6.5),
              child: CircleAvatar(
                radius: 2,
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: content,
          )
        ],
      ),
    );
  }
}
