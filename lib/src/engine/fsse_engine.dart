import 'dart:convert';

import 'package:fsse/src/engine/data/item_result.dart';
import 'package:fsse/src/engine/data/profile.dart';
import 'package:fsse/src/engine/state_saver.dart';

import 'data/conversation.dart';
import 'data/scene.dart';
import 'data/items/base.dart';

import 'package:flutter/services.dart' show rootBundle;

import 'dart:developer' as developer;

abstract class EngineLoader {
  Future<ProfileData> loadProfile();

  Future<Conversation> loadInitialConversation();

  Future<Conversation> loadConversation(String conversationId);
}

abstract class FsseEngine {
  /// Proceed to next item. You can provide the previous result of item type
  /// This result object can have a data that will be stored in data map
  /// or will load next conversation
  Future<ItemType> next({ItemResult? prevResult});

  /// Get current item of item type.
  Future<ItemType> get();

  /// Get data map from engine container map
  Map<String, dynamic> getDataMap();

  /// Get profile for item type
  Profile? getProfile(ItemType itemType);

  void save();
}

abstract class EngineListener {
  /// Called when new scene (background and or music) is available
  void onNewScene(Scene scene);
}

class LoaderConfig {
  late String storyDir;
  late String musicDir;
  late String spritesDir;
  late String bgDir;

  LoaderConfig(
      {this.storyDir = "assets/story",
      this.musicDir = "assets/story/music",
      this.spritesDir = "assets/story/sprites",
      this.bgDir = "assets/story/bg"});
}

/* Impl */
/* ------------------------------------------ */

class AssetEngineLoader extends EngineLoader {
  late LoaderConfig config;

  AssetEngineLoader(this.config);

  @override
  Future<Conversation> loadConversation(String conversationId) async {
    String newConversation = await rootBundle.loadString("${config.storyDir}/$conversationId.json");
    return Conversation.fromJson(jsonDecode(newConversation));
  }

  @override
  Future<Conversation> loadInitialConversation() async {
    String conversationString = await rootBundle.loadString("${config.storyDir}/index.json");
    return Conversation.fromJson(jsonDecode(conversationString));
  }

  @override
  Future<ProfileData> loadProfile() async {
    String profileString = await rootBundle.loadString("${config.storyDir}/profiles.json");
    return ProfileData.fromJson(jsonDecode(profileString));
  }
}

class RealFsseEngine extends FsseEngine {
  static const _tag = "FSSE";

  late EngineLoader loader;
  late CeritaStateSaver stateSaver;
  EngineListener? listener;

  RealFsseEngine(this.loader, this.stateSaver, this.listener);

  late ProfileData profileData;

  Conversation? currentConversation;
  int dialogIndex = 0;

  Map<String, String> dataMap = {};

  @override
  Future<ItemType> next({ItemResult? prevResult}) async {
    developer.log("Request next with index: $dialogIndex", name: _tag);

    await _loadPackageIfNeeded();
    _handleResult(prevResult);

    final result = await _getCurrentItemType();
    dialogIndex += 1;
    return result;
  }

  @override
  Future<ItemType> get() async {
    developer.log("Request get with index: $dialogIndex", name: _tag);
    await _loadPackageIfNeeded();
    return _getCurrentItemType();
  }

  @override
  Map<String, dynamic> getDataMap() => dataMap;

  @override
  Profile? getProfile(ItemType itemType) {
    final info = itemType.getProfileInfo();
    if (info == null) {
      return null;
    }
    try {
      return profileData.profiles.firstWhere((element) => element.id == info.id);
    } catch (e) {
      return null;
    }
  }

  Future<ItemType> _getCurrentItemType() {
    final conversation = currentConversation;
    if (conversation == null) {
      return Future.error(Exception("Empty conversation. Are you already load the assets?"));
    }

    if (dialogIndex >= conversation.conversations.length) {
      return Future.error(Exception("End of conversations"));
    }

    final newData = conversation.conversations[dialogIndex].cloneWithData(dataMap);
    return Future.value(newData);
  }

  void _handleResult(ItemResult? itemResult) async {
    if (itemResult == null) return;

    // Handle data map
    if (itemResult.variable != null) {
      if (itemResult.value == null) {
        throw Exception("Variable exits but value is null");
      }
      dataMap[itemResult.variable!] = itemResult.value ?? "";
    }

    // Handle target
    final target = itemResult.target;
    if (target != null) {
      final conversation = await loader.loadConversation(target);
      _onNewConversation(conversation);

      // Change with thread-safe operation
      dialogIndex = 0;
    }
  }

  Future<bool> _loadPackageIfNeeded() async {
    if (currentConversation == null) {
      final lastState = await stateSaver.loadState();

      developer.log("last state is ${jsonEncode(lastState)}", name: _tag);

      Conversation conversation;
      try {
        conversation = lastState == EmptyState
            ? await loader.loadInitialConversation()
            : await loader.loadConversation(lastState.conversationId);
      } catch (e) {
        // fallback to index conversation because index conversation naming issue
        conversation = await loader.loadInitialConversation();
      }

      developer.log("Resume from conversation id: $conversation", name: _tag);

      profileData = await loader.loadProfile();
      _onNewConversation(conversation);

      developer.log("Package loaded", name: _tag);
      return true;
    }
    return false;
  }

  /// This is called after initial load
  /// and after new conversation is loaded
  void _onNewConversation(Conversation conversation) {
    currentConversation = conversation;
    listener?.onNewScene(conversation.scene);
  }

  @override
  void save() {
    final conversationId = currentConversation?.conversationId;
    if (conversationId == null) {
      developer.log("State is not saved", name: _tag);
      return;
    }

    stateSaver.saveState(CeritaState(conversationId, dialogIndex));
    developer.log("State saved. Conversation: ${currentConversation?.conversationId ?? "null"}", name: _tag);
  }
}
