import 'base.dart';

class InputItemType extends ItemType {
  static const type = "INPUT";

  late String text, variable;

  InputItemType.fromJson(Map<String, dynamic> json) {
    text = json["text"];
    variable = json["variable"];
  }

  @override
  String getType() => type;
}
