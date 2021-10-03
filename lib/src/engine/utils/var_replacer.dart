final variablePattern = RegExp(r"{{([a-zA-Z]+)}}");

extension VariableReplacer on String {
  String replaceWithVars(Map<String, String> dataMap) {
    final originalData = this;

    RegExpMatch? result = variablePattern.firstMatch(originalData);

    var newData = originalData;

    while (true) {
      // If there's not variable place holder, return original data
      if (result == null) {
        return newData;
      }

      final varName = result.group(1);
      final data = dataMap[varName];
      if (data == null) {
        throw Exception("Variable $varName not exist in data map");
      }
      newData = newData.replaceRange(result.start, result.end, data);

      // Go to next iteration
      result = variablePattern.firstMatch(newData);
    }
  }
}
