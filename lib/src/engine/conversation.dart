import 'package:fsse/src/engine/items/choice.dart';
import 'package:fsse/src/engine/items/input.dart';
import 'package:fsse/src/engine/items/text.dart';

import 'items/base.dart';

class Conversation {
  late String conversationId;
  late List<ItemType> conversations;

  Conversation.fromJson(Map<String, dynamic> json) {
    conversationId = json["conversation_id"];

    List<dynamic> jsonConv = json["conversations"];
    conversations = jsonConv.map((item) {
      String type = item["type"];
      switch (type) {
        case ChoiceItemType.type:
          return ChoiceItemType.fromJson(item);
        case TextItemType.type:
          return TextItemType.fromJson(item);
        case InputItemType.type:
          return InputItemType.fromJson(item);
        default:
          throw Exception("Can't handle $type in conversation");
      }
    }).toList();
  }
}
