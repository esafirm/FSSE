import 'base.dart';

import 'package:fsse/src/engine/utils/var_replacer.dart';

class InputItemType extends ItemType {
  static const type = "INPUT";

  late String text, variable;

  InputItemType(this.text, this.variable);

  InputItemType.fromJson(Map<String, dynamic> json) {
    text = json["text"];
    variable = json["variable"];
  }

  @override
  String getType() => type;

  @override
  String? getText() => text;

  @override
  ItemType cloneWithData(Map<String, String> data) {
    return InputItemType(text.replaceWithVars(data), variable);
  }
}
