class Scene {
  late String background;
  late String music;

  Scene.fromJson(Map<String, dynamic> json) {
    background = json["background"];
    music = json["music"];
  }

  Scene({required this.background, required this.music});
}
