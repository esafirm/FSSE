import 'dart:convert';

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
  Future<EnginePackage> load();
}

abstract class FsseEngine {
  Future<ItemType> proceed();
}

/* Impl */
/* ------------------------------------------ */

class AssetEngineLoader extends EngineLoader {
  @override
  Future<EnginePackage> load() async {
    String profileString = await rootBundle.loadString("assets/story/profiles.json");
    String conversationString = await rootBundle.loadString("assets/story/index.json");

    return EnginePackage.fromJsonFiles(jsonDecode(profileString), jsonDecode(conversationString));
  }
}

class RealFsseEngine extends FsseEngine {
  late EngineLoader loader;

  RealFsseEngine(this.loader);

  late EnginePackage package;

  ItemType? currentItem;

  @override
  Future<ItemType> proceed() async {
    if (currentItem == null) {
      package = await loader.load();

      developer.log("Package loaded", name: "FSSE");
    }

    return package.conversation.conversations.first;
  }
}
