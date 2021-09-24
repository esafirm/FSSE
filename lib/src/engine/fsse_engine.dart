import 'package:flutter/material.dart';

class Conversation {}

class Profile {}

class EnginePackage {
  late Conversation conversation;
  late Profile profile;
}

abstract class EngineLoader {
  EnginePackage load();
}

abstract class FsseEngine {
  late EngineLoader loader;

  ItemType proceed();
}

abstract class ItemType {
  String type();
}

class InputResult {
  String? variable;
}

class TextItemType extends ItemType {
  static const _type = "TEXT";
  late String text, profileId;

  TextItemType({@required text, @required profileId});

  TextItemType.fromJson(Map<String, dynamic> json) {
    text = json["text"];
    profileId = json["profileId"];
  }

  @override
  String type() {
    return _type;
  }
}

class InputItemType extends ItemType {
  static const _type = "INPUT";

  late String text, variable;

  InputItemType.fromJson(Map<String, dynamic> json) {
    text = json["text"];
    variable = json["variable"];
  }

  @override
  String type() {
    return _type;
  }
}

class ChoiceItemType extends ItemType {
  String? text;
  String? variable;
  String?
  
}

void main() {
  TextItemType(text: "Testing", profileId: "Profile ID");
}
