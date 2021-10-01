import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fsse/src/engine/fsse_engine.dart';

import 'dart:developer' as developer;

import 'package:fsse/src/engine/item_result.dart';
import 'package:fsse/src/engine/items/choice.dart';
import 'package:fsse/src/engine/items/input.dart';

class SimpleConversation extends StatefulWidget {
  const SimpleConversation({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SimpleConversationState();
}

class SimpleConversationState extends State<SimpleConversation> {
  FsseEngine? engine;
  String? currentText;

  Widget buildItem(BuildContext context, String label, Function() onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          child: Text(label),
          onPressed: onPressed,
        ),
      ),
    );
  }

  Future<ItemResult?> getItemResult() async {
    final item = await engine?.get();
    developer.log("Current item $item");

    if (item is InputItemType) {
      return ItemResult.input(item.variable, "TikTok");
    }
    if (item is ChoiceItemType) {
      final firstChoice = item.choices.first;
      return ItemResult.choice(item.variable, firstChoice.value, firstChoice.target);
    }
    return null;
  }

  Widget buildButtons(BuildContext context) {
    return Row(
      children: [
        buildItem(context, "Proceed", () async {
          engine ??= RealFsseEngine(AssetEngineLoader());

          final itemResult = await getItemResult();
          final nextItem = await engine?.next(prevResult: itemResult);

          developer.log("Prev result is $itemResult");
          developer.log("Next item is $nextItem");

          setState(() {
            currentText = nextItem?.getText();
          });
        }),
        buildItem(context, "Print Data", () async {
          final dataMap = engine?.getDataMap();

          developer.log("Inspecting data map: ${jsonEncode(dataMap)}");
          developer.inspect(dataMap);
        }),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("FSSE Sample"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            buildButtons(context),
            Text(currentText ?? "No item")
          ],
        ),
      ),
    );
  }
}
