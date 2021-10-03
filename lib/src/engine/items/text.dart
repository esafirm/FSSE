import 'base.dart';
import 'package:fsse/src/engine/utils/var_replacer.dart';

class TextItemType extends ItemType {
  static const type = "TEXT";
  late String text;
  String? profileId;

  TextItemType(this.text, this.profileId);

  TextItemType.fromJson(Map<String, dynamic> json) {
    text = json["text"];
    profileId = json["profile"];
  }

  @override
  String getType() => type;

  @override
  String? getText() => text;

  @override
  ItemType cloneWithData(Map<String, String> data) {
    return TextItemType(text.replaceWithVars(data), profileId?.replaceWithVars(data));
  }
}
