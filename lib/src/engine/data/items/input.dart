import 'base.dart';

import 'package:fsse/src/engine/utils/var_replacer.dart';
import 'package:fsse/src/engine/data/items/profile_info.dart';

class InputItemType extends ItemType {
  static const type = "INPUT";

  late String text, variable;
  ProfileInfo? profile;

  InputItemType(this.text, this.variable, this.profile);

  InputItemType.fromJson(Map<String, dynamic> json) {
    text = json["text"];
    variable = json["variable"];

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
    return InputItemType(text.replaceWithVars(data), variable, profile);
  }
}
