import 'package:flutter/material.dart';
import 'package:fsse/src/simpleconversation/simple_conversation.dart';

import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();
  runApp(const SimpleConversation());
}
