import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DialogueBox extends StatelessWidget {
  final String _name;
  final String _message;

  DialogueBox(this._name, this._message);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(160),
        border: Border.all(color: Colors.blue, width: 2, style: BorderStyle.solid),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_name),
          TweenAnimationBuilder<int>(
            key: Key(_message),
            builder: (context, value, child) {
              print("text: $_message value: $value");

              return Text(_message.substring(0, value) + "_",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500));
            },
            duration: const Duration(seconds: 2),
            tween: IntTween(begin: 0, end: _message.length),
          )
        ],
      ),
    );
  }
}
