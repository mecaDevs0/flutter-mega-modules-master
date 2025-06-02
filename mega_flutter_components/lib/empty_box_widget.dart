import 'package:flutter/material.dart';
import 'package:megaleios_flutter_localization/megaleios_flutter_localization.dart';

class EmptyBoxWidget extends StatelessWidget {
  const EmptyBoxWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F2F2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/empty_box.gif',
            package: 'mega_flutter_components',
            height: 300,
          ),
          Text(
            MegaleiosLocalizations.of(context)!.translate('no_records_found'),
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
