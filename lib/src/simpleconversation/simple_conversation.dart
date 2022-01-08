import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fsse/src/engine/fsse_engine.dart';

import 'package:fsse/src/engine/data/item_result.dart';
import 'package:fsse/src/engine/data/items/choice.dart';
import 'package:fsse/src/engine/data/items/input.dart';
import 'package:fsse/src/engine/data/scene.dart';
import 'package:fsse/src/engine/state_saver.dart';

import 'package:fsse/src/simpleconversation/audio_helper.dart';
import 'package:fsse/src/simpleconversation/widgets/dialogue_box.dart';
import 'package:fsse/src/simpleconversation/widgets/scene.dart';
import 'package:fsse/src/simpleconversation/widgets/simple_menu.dart';
import 'package:fsse/src/simpleconversation/widgets/toggle_visibility.dart';
import 'package:fsse/src/utils/logger.dart';

class SimpleConversation extends StatefulWidget {
  const SimpleConversation({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SimpleConversationState();
}

class SimpleConversationState extends State<SimpleConversation> implements EngineListener {

  Logger logger = Logger("SimpleConversation");

  AudioHelper audioPlayer = AudioHelper();
  LoaderConfig config = LoaderConfig(musicDir: "story/music");

  late FsseEngine engine;
  String? currentText;

  String? profileImage;
  String? backgroundImage;
  bool _hideUis = true;

  SimpleConversationState() {
    engine = RealFsseEngine(AssetEngineLoader(config), SharedPrefCeritaStateSaver(), this);
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
    logger.log("on new bg: ${scene.background}");
    logger.log("on new music: ${scene.music}");

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
    logger.log("Current item $item");

    if (item is InputItemType) {
      return ItemResult.input(item.variable, "TikTok");
    }
    if (item is ChoiceItemType) {
      final firstChoice = item.choices.first;
      return ItemResult.choice(item.variable, firstChoice.value, firstChoice.target);
    }
    return null;
  }

  void proceedToNextItem() async {
    final itemResult = await getItemResult();
    final nextItem = await engine.next(prevResult: itemResult);
    final profile = engine.getProfile(nextItem);

    logger.log("Prev result is $itemResult");
    logger.log("Next item is $nextItem");

    setState(() {
      currentText = nextItem.getText();

      if (profile != null) {
        final spriteName = profile.getSprite(nextItem.getProfileInfo()!);
        profileImage = "${config.spritesDir}/$spriteName";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPoiAvailable = backgroundImage != null || profileImage != null;

    return MaterialApp(
      theme: ThemeData(),
      home: Scaffold(
        body: InkWell(
          onTap: proceedToNextItem,
          onLongPress: () {
            setState(() {
              _hideUis = !_hideUis;
            });
          },
          child: Stack(
            children: [
              isPoiAvailable ? SceneWidget(backgroundImage!, profileImage!) : const SizedBox.shrink(),
              ToggleVisibility(
                  isVisible: _hideUis,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8, top: 64),
                      child: InGameMenu(onSaveTap: () {
                        engine.save();
                      }),
                    ),
                  )),
              ToggleVisibility(
                isVisible: _hideUis,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: currentText != null ? DialogueBox(currentText!) : const SizedBox.shrink(),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
