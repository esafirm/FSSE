import 'base.dart';

class ChoiceItemType extends ItemType {
  static const type = "CHOICE";

  late String text;
  String? variable;

  late List<Choice> choices;

  ChoiceItemType.fromJson(Map<String, dynamic> json) {
    text = json["text"];
    variable = json["variable"];

    List<dynamic> jsonChoices = json["choices"];

    choices = jsonChoices.map((element) {
      return Choice.fromJson(element);
    }).toList();
  }

  @override
  String getType() => type;
}

class Choice {
  late String text;
  String? value;
  String? target;

  Choice.fromJson(Map<String, dynamic> json) {
    text = json["text"];
    value = json["value"];
    target = json["target"];
  }
}
