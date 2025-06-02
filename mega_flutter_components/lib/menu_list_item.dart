import 'package:flutter/material.dart';

class MenuListItem extends StatelessWidget {
  final String title;
  final String? leadingImage;
  final TextStyle? style;
  final bool enabled;
  final bool hasTrailing;
  final bool hasDivider;
  final bool hasBadge;
  final Function()? onTap;
  final String badge;

  MenuListItem(
    this.title, {
    this.leadingImage,
    required this.style,
    this.enabled = true,
    this.hasTrailing = false,
    this.hasDivider = false,
    this.hasBadge = false,
    this.onTap,
    this.badge = '',
  }) : assert(title.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _leadingWidget(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Text(
                      title,
                      style: style ?? Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                Row(
                  children: [
                    if (hasBadge)
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          badge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    Visibility(
                      visible: hasTrailing,
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: style!.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 5),
              ],
            ),
          ),
          Visibility(
            visible: hasDivider,
            child: const Divider(
              height: 1,
              thickness: 1,
            ),
          )
        ],
      ),
    );
  }

  _leadingWidget() {
    if (leadingImage == null || leadingImage!.trim().isEmpty) {
      return Container();
    }

    return SizedBox(
      width: 20,
      child: Center(
        child: Image.asset(
          leadingImage!,
          height: 16,
          color: style!.color,
        ),
      ),
    );
  }
}
