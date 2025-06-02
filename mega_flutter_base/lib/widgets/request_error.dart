import 'dart:io';

import 'package:flutter/material.dart';

import '../mega_base_bloc.dart';

class RequestError extends StatelessWidget {
  const RequestError({
    Key? key,
    required this.appBloc,
  }) : super(key: key);

  final MegaBaseBloc appBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/time_out_error.png',
              package: 'mega_flutter_base',
              height: 162,
            ),
            const SizedBox(height: 60),
            const Text(
              "Algo deu errado...",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff29224f),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Mas logo será resolvido.\nPor favor, volte mais tarde.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff666666),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 60),
            GestureDetector(
              onTap: () {
                appBloc.setHasRequestError(false);
                exit(0);
              },
              child: Container(
                height: 52,
                width: 200,
                decoration: const BoxDecoration(
                  color: Color(0xff06B12E),
                ),
                child: const Center(
                  child: Text(
                    "Ok, entendi",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
