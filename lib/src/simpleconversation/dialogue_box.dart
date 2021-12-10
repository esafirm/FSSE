import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:animated_text_kit/animated_text_kit.dart';

import 'dart:developer' as developer;

class DialogueBox extends StatelessWidget {
  final String _text;

  const DialogueBox(this._text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(160),
        border: Border.all(color: Colors.blue, width: 2, style: BorderStyle.solid),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Text(
        _text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }
}
