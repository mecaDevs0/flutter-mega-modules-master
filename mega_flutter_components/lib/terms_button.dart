import 'package:flutter/material.dart';
import 'package:megaleios_flutter_localization/megaleios_flutter_localization.dart';

class TermsButton extends StatelessWidget {
  final bool accepted;
  final TextStyle normalTheme;
  final TextStyle boldTheme;
  final Function(bool)? onChange;
  final Function()? onTapTerms;

  const TermsButton({
    required this.normalTheme,
    required this.boldTheme,
    this.accepted = false,
    this.onChange,
    this.onTapTerms,
  });

  @override
  Widget build(BuildContext context) {
    final localization = MegaleiosLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        children: <Widget>[
          Stack(children: [
            Center(
              child: Checkbox(
                  value: accepted,
                  onChanged: (value) => onChange!(!this.accepted)),
            ),
            Positioned.fill(
                child: GestureDetector(onTap: () => onChange!(!this.accepted)))
          ]),
          Expanded(
            child: GestureDetector(
              onTap: onTapTerms != null
                  ? onTapTerms
                  : () => onChange!(!this.accepted),
              child: RichText(
                text: TextSpan(
                  text: localization.translate('agree_terms1'),
                  style: normalTheme,
                  children: <TextSpan>[
                    TextSpan(
                      text: localization.translate('agree_terms2'),
                      style: boldTheme,
                    ),
                    TextSpan(
                      text: localization.translate('agree_terms3'),
                    ),
                    TextSpan(
                      text: localization.translate('agree_terms4'),
                      style: boldTheme,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
