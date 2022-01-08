import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsse/src/engine/data/item_result.dart';
import 'package:fsse/src/engine/data/items/base.dart';
import 'package:fsse/src/engine/data/items/choice.dart';
import 'package:fsse/src/engine/data/items/input.dart';
import 'package:fsse/src/engine/data/profile.dart';
import 'package:fsse/src/engine/data/scene.dart';
import 'package:fsse/src/engine/fsse_engine.dart';
import 'package:fsse/src/engine/state_saver.dart';
import 'package:fsse/src/utils/logger.dart';

import 'audio_helper.dart';

final AudioHelper audioPlayer = AudioHelper();

final LoaderConfig config = LoaderConfig(musicDir: "story/music");

class GameState {
  final Profile? currentProfile;
  final Scene? currentScene;
  final ItemType? currentItemType;
  final bool hideUis;

  GameState({this.currentProfile, this.currentScene, this.currentItemType, this.hideUis = true});

  bool isSceneAvailable() => currentScene != null;

  String getProfileSprite() {
    final spriteName = currentProfile?.getSprite(currentItemType!.getProfileInfo()!);
    return "${config.spritesDir}/$spriteName";
  }

  String getProfileName() => currentProfile?.name ?? "[????]";

  String? currentTextDialogue() => currentItemType?.getText();
}

final gameStateProvider = StateNotifierProvider<GameController, GameState>((ref) {
  return GameController(GameState());
});

class GameController extends StateNotifier<GameState> implements EngineListener {
  Logger logger = Logger("GameController");

  late FsseEngine engine;
  LoaderConfig config = LoaderConfig(musicDir: "story/music");

  GameController(GameState state) : super(state) {
    engine = RealFsseEngine(AssetEngineLoader(config), SharedPrefCeritaStateSaver(), this);
    audioPlayer.addObserver();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.removeObserver();
  }

  @override
  void onNewScene(Scene scene) {
    state = GameState(
        currentItemType: state.currentItemType,
        currentProfile: state.currentProfile,
        currentScene:
        Scene(music: "${config.musicDir}/${scene.music}", background: "${config.bgDir}/${scene.background}"));

    audioPlayer.play(state.currentScene!.music);
  }

  void nextItem() async {
    final itemResult = await _getItemResult();
    final nextItem = await engine.next(prevResult: itemResult);
    final profile = engine.getProfile(nextItem);

    logger.log("Profile is: $profile");

    state = GameState(currentItemType: nextItem, currentProfile: profile, currentScene: state.currentScene);
  }

  void save() {
    engine.save();
  }

  void toggleHideUi() {
    state = GameState(hideUis: !state.hideUis);
  }

  Future<ItemResult?> _getItemResult() async {
    final item = await engine.get();

    if (item is InputItemType) {
      return ItemResult.input(item.variable, "TikTok");
    }
    if (item is ChoiceItemType) {
      final firstChoice = item.choices.first;
      return ItemResult.choice(item.variable, firstChoice.value, firstChoice.target);
    }
    return null;
  }
}
