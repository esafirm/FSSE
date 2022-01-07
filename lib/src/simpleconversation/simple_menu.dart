import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnSaveTap = void Function();

class InGameMenu extends StatelessWidget {
  InGameMenu({required this.onSaveTap});

  final OnSaveTap onSaveTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 3), // changes position of shadow
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: onSaveTap,
              child: const Icon(
                Icons.save_rounded,
                color: Colors.pink,
                size: 24.0,
                semanticLabel: 'Save Game',
              ),
            )
          ],
        ),
      ),
    );
  }
}
