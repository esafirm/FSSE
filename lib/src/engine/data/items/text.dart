import 'base.dart';
import 'package:fsse/src/engine/utils/var_replacer.dart';
import 'package:fsse/src/engine/data/items/profile_info.dart';

class TextItemType extends ItemType {
  static const type = "TEXT";
  late String text;
  ProfileInfo? profile;

  TextItemType(this.text, this.profile);

  TextItemType.fromJson(Map<String, dynamic> json) {
    text = json["text"];

    String? profileIdentifier = json["profile"];
    if (profileIdentifier != null) {
      profile = ProfileInfo.fromIdentifier(profileIdentifier);
    }
  }

  @override
  String getType() => type;

  @override
  String? getText() => text;

  @override
  ProfileInfo? getProfileInfo() => profile;

  @override
  ItemType cloneWithData(Map<String, String> data) {
    return TextItemType(text.replaceWithVars(data), profile);
  }
}
