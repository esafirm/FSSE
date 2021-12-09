import 'package:flutter/widgets.dart';

import 'package:audioplayers/audioplayers.dart';

/// Helper class to handle background music in the widget
/// It automatically stop the last sound and it also
/// react to [AppLifecycleState]
class AudioHelper with WidgetsBindingObserver {

  AudioCache audioCache = AudioCache();
  AudioPlayer? audioPlayer;

  void addObserver() {
    WidgetsBinding.instance?.addObserver(this);
  }

  void removeObserver() {
    WidgetsBinding.instance?.removeObserver(this);
  }

  void play(String audioFile) async {
    await audioPlayer?.stop();
    audioPlayer = await audioCache.play(audioFile);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _handleLifecycle(state);
  }

  void _handleLifecycle(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      audioPlayer?.resume();
    }
    if (state == AppLifecycleState.paused) {
      audioPlayer?.pause();
    }
  }
}
