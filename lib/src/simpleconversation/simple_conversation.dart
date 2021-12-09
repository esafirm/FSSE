import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fsse/src/engine/fsse_engine.dart';

import 'dart:developer' as developer;

import 'package:fsse/src/engine/data/item_result.dart';
import 'package:fsse/src/engine/data/items/choice.dart';
import 'package:fsse/src/engine/data/items/input.dart';
import 'package:fsse/src/engine/data/scene.dart';

import 'package:fsse/src/simpleconversation/audio_helper.dart';
import 'package:fsse/src/simpleconversation/poi.dart';

class SimpleConversation extends StatefulWidget {
  const SimpleConversation({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SimpleConversationState();
}

class SimpleConversationState extends State<SimpleConversation> implements EngineListener {
  AudioHelper audioPlayer = AudioHelper();
  LoaderConfig config = LoaderConfig(musicDir: "story/music");

  late FsseEngine engine;
  String? currentText;

  String? profileImage;
  String? backgroundImage;

  SimpleConversationState() {
    engine = RealFsseEngine.withListener(AssetEngineLoader(config), this);
  }

  @override
  void initState() {
    super.initState();
    audioPlayer.addObserver();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.removeObserver();
  }

  @override
  void onNewScene(Scene scene) {
    developer.log("on new bg: ${scene.background}");
    developer.log("on new music: ${scene.music}");

    audioPlayer.play("${config.musicDir}/${scene.music}");

    setState(() {
      backgroundImage = "${config.bgDir}/${scene.background}";
    });
  }

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
    final item = await engine.get();
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
          final itemResult = await getItemResult();
          final nextItem = await engine.next(prevResult: itemResult);
          final profile = engine.getProfile(nextItem);

          developer.log("Prev result is $itemResult");
          developer.log("Next item is $nextItem");

          setState(() {
            currentText = nextItem.getText();

            if (profile != null) {
              final spriteName = profile.getSprite(nextItem.getProfileInfo()!);
              profileImage = "${config.spritesDir}/$spriteName";
            }
          });
        }),
        buildItem(context, "Print Data", () async {
          final dataMap = engine.getDataMap();

          developer.log("Inspecting data map: ${jsonEncode(dataMap)}");
          developer.inspect(dataMap);
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPoiAvailable = backgroundImage != null || profileImage != null;

    final children = [
      buildButtons(context),
      Text(currentText ?? "No item"),
      isPoiAvailable ? Poi(backgroundImage!, profileImage!) : null
    ].whereType<Widget>().toList();

    return MaterialApp(
      theme: ThemeData(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("FSSE Sample"),
          centerTitle: true,
        ),
        body: Column(
          children: children,
        ),
      ),
    );
  }
}
