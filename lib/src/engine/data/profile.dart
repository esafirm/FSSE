import 'items/profile_info.dart';

class ProfileData {
  late List<Profile> profiles;

  ProfileData.fromJson(Map<String, dynamic> json) {
    profiles = json["profiles"].map<Profile>((item) {
      return Profile.fromJson(item);
    }).toList();
  }
}

class Profile {
  late String id;
  late String name;
  late String avatar;
  late List<String> sprites;

  Profile.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    avatar = json["avatar"];

    sprites = json["sprites"].map<String>((item) {
      // Hardcoded for now
      return "assets/story/sprites/$item";
    }).toList();
  }

  String getSprite(ProfileInfo info) {
    final index = int.parse(info.sprite);
    return sprites[index];
  }
}
