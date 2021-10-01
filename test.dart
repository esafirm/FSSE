import 'package:fsse/src/engine/utils/var_replacer.dart';

void main() {
  const template = "Hi my name is {{NAME}} {{HAHA}}";
  final data = {'NAME': 'TikTok', 'HAHA': 'Ketawa'};

  final result = template.replaceWithVars(data);

  print("All matches: $result");
}
