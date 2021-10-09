import 'package:fsse/src/engine/data/items/profile_info.dart';

import 'base.dart';
import 'package:fsse/src/engine/utils/var_replacer.dart';

class ChoiceItemType extends ItemType {
  static const type = "CHOICE";

  late String text;
  String? variable;
  ProfileInfo? profile;

  late List<Choice> choices;

  ChoiceItemType(this.text, this.variable, this.profile, this.choices);

  ChoiceItemType.fromJson(Map<String, dynamic> json) {
    text = json["text"];
    variable = json["variable"];

    List<dynamic> jsonChoices = json["choices"];

    choices = jsonChoices.map((element) {
      return Choice.fromJson(element);
    }).toList();

    String? profileIdentifier = json["profile"];
    if (profileIdentifier != null) {
      profile = ProfileInfo.fromIdentifier(profileIdentifier);
    }
  }

  @override
  String? getText() => text;

  @override
  String getType() => type;

  @override
  ProfileInfo? getProfileInfo() => profile;

  @override
  ItemType cloneWithData(Map<String, String> data) {
    final newChoices =
        choices.map((e) => Choice(e.text.replaceWithVars(data), e.value?.replaceWithVars(data), e.target)).toList();
    return ChoiceItemType(text.replaceWithVars(data), variable, profile, newChoices);
  }
}

class Choice {
  late String text;
  String? value;
  String? target;

  Choice(this.text, this.value, this.target);

  Choice.fromJson(Map<String, dynamic> json) {
    text = json["text"];
    value = json["value"];
    target = json["target"];
  }
}
