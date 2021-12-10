import 'package:flutter/material.dart';

import 'dart:developer' as developer;

/// [Poi] handles the actor image and background image
class Poi extends StatelessWidget {
  final String _background;
  final String? _actor;

  const Poi(this._background, this._actor, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    developer.log("Return image content");

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(_background, fit: BoxFit.fitWidth),
        Padding(
          padding: const EdgeInsets.only(top: 32),
          child: _actor == null ? const SizedBox.shrink() : Image.asset(_actor!, fit: BoxFit.fitHeight),
        ),
      ],
    );
  }
}
