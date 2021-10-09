class Scene {
  late String background;
  late String music;

  Scene.fromJson(Map<String, dynamic> json) {
    // Hardcoded for now.
    // TODO: find a way to make this configurable
    background = "assets/story/bg/${json["background"]}";
    music = "story/music/${json["music"]}";
  }
}
