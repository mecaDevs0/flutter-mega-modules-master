import 'package:flutter/material.dart';
import 'package:mega_flutter_components/animated_column.dart';
import 'package:megaleios_flutter_localization/megaleios_flutter_localization.dart';

class NoNetworkConnection extends StatelessWidget {
  const NoNetworkConnection({
    Key? key,
    required this.onTryAgain,
    required this.isCheckingConnection,
  }) : super(key: key);

  final VoidCallback onTryAgain;
  final bool isCheckingConnection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(40),
              child: AnimatedColumn(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    MegaleiosLocalizations.of(context)!
                        .translate('no_network_access'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(height: 12),
                  FractionallySizedBox(
                    widthFactor: 0.6,
                    child: InkWell(
                      onTap: onTryAgain,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: const Color(0xFF06B12E),
                        ),
                        child: isCheckingConnection
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Tentar novamente',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
