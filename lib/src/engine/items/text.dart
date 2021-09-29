import 'package:flutter/widgets.dart';

import 'base.dart';

class TextItemType extends ItemType {
  static const type = "TEXT";
  late String text, profileId;

  TextItemType({@required text, @required profileId});

  TextItemType.fromJson(Map<String, dynamic> json) {
    text = json["text"];
    profileId = json["profile"];
  }

  @override
  String getType() => type;
}
