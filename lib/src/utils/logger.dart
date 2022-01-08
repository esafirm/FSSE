import 'dart:developer' as developer;

class Logger {
  Logger(this.tag);

  final String tag;

  void log(String message) {
    developer.log(message, name: tag);
  }

  void inspect(dynamic object) {
    developer.inspect(object);
  }
}
