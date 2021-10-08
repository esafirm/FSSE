import 'items/base.dart';
import 'items/choice.dart';
import 'items/input.dart';
import 'items/text.dart';
import 'scene.dart';

class Conversation {
  late String conversationId;
  late List<ItemType> conversations;
  late Scene scene;

  Conversation.fromJson(Map<String, dynamic> json) {
    conversationId = json["conversation_id"];
    scene = Scene.fromJson(json["scene"]);

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
