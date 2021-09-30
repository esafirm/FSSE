import 'dart:convert';

import 'package:fsse/src/engine/item_result.dart';
import 'package:fsse/src/engine/profile.dart';

import 'conversation.dart';
import 'items/base.dart';

import 'package:flutter/services.dart' show rootBundle;

import 'dart:developer' as developer;

class EnginePackage {
  late Conversation conversation;
  late Profile profiles;

  EnginePackage.fromJsonFiles(dynamic profiles, dynamic conversation) {
    this.conversation = Conversation.fromJson(conversation);
    this.profiles = Profile.fromJson(profiles);
  }
}

abstract class EngineLoader {
  Future<EnginePackage> initialLoad();

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
}

/* Impl */
/* ------------------------------------------ */

class AssetEngineLoader extends EngineLoader {
  static const String _assetDir = "assets/story";
  static const String _prefixConversation = "cvn_";

  @override
  Future<EnginePackage> initialLoad() async {
    String profileString = await rootBundle.loadString("$_assetDir/profiles.json");
    String conversationString = await rootBundle.loadString("$_assetDir/index.json");

    return EnginePackage.fromJsonFiles(jsonDecode(profileString), jsonDecode(conversationString));
  }

  @override
  Future<Conversation> loadConversation(String conversationId) async {
    String newConversation = await rootBundle.loadString("$_assetDir/$_prefixConversation$conversationId.json");
    return Conversation.fromJson(jsonDecode(newConversation));
  }
}

class RealFsseEngine extends FsseEngine {
  static const _tag = "FSSE";

  late EngineLoader loader;

  RealFsseEngine(this.loader);

  late Profile profile;

  Conversation? currentConversation;
  int dialogIndex = 0;

  Map<String, dynamic> dataMap = {};

  @override
  Future<ItemType> next({ItemResult? prevResult}) async {
    developer.log("Request next with index: $dialogIndex", name: _tag);

    await loadPackageIfNeeded();
    handleResult(prevResult);

    final result = await getCurrentItemType();
    dialogIndex += 1;
    return result;
  }

  @override
  Future<ItemType> get() async {
    developer.log("Request get with index: $dialogIndex", name: _tag);
    await loadPackageIfNeeded();
    return getCurrentItemType();
  }

  @override
  Map<String, dynamic> getDataMap() => dataMap;

  Future<ItemType> getCurrentItemType() {
    return Future.value(currentConversation!.conversations[dialogIndex]);
  }

  void handleResult(ItemResult? itemResult) async {
    if (itemResult == null) return;

    // Handle data map
    if (itemResult.variable != null) {
      if (itemResult.value == null) {
        throw Exception("Variable exits but value is null");
      }
      dataMap[itemResult.variable!] = itemResult.value;
    }

    // Handle target
    final target = itemResult.target;
    if (target != null) {
      await loader.loadConversation(target);
    }
  }

  Future<bool> loadPackageIfNeeded() async {
    if (currentConversation == null) {
      final package = await loader.initialLoad();
      profile = package.profiles;
      currentConversation = package.conversation;

      developer.log("Package loaded", name: "FSSE");
      return true;
    }
    return false;
  }
}
