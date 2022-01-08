import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fsse/src/simpleconversation/game_state.dart';
import 'package:fsse/src/simpleconversation/widgets/dialogue_box.dart';
import 'package:fsse/src/simpleconversation/widgets/scene.dart';
import 'package:fsse/src/simpleconversation/widgets/simple_menu.dart';
import 'package:fsse/src/simpleconversation/widgets/toggle_visibility.dart';
import 'package:fsse/src/utils/logger.dart';

class SimpleConversation extends ConsumerWidget {
  Logger logger = Logger("SimpleConversation");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final notifier = ref.watch(gameStateProvider.notifier);
    final isPoiAvailable = gameState.isSceneAvailable();

    final currentText = gameState.currentTextDialogue();

    return MaterialApp(
      theme: ThemeData(),
      home: Scaffold(
        body: InkWell(
          onTap: notifier.nextItem,
          onLongPress: notifier.toggleHideUi,
          child: Stack(
            children: [
              isPoiAvailable
                  ? SceneWidget(gameState.currentScene!.background, gameState.getProfileSprite())
                  : const SizedBox.shrink(),
              ToggleVisibility(
                  isVisible: gameState.hideUis,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8, top: 64),
                      child: InGameMenu(onSaveTap: () => notifier.save()),
                    ),
                  )),
              ToggleVisibility(
                isVisible: gameState.hideUis,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: currentText != null
                          ? DialogueBox(gameState.getProfileName(), currentText)
                          : const SizedBox.shrink(),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
