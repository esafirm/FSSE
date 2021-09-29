class Profile {
  late List<ProfileItem> profiles;

  Profile.fromJson(Map<String, dynamic> json) {
    profiles = json["profiles"].map<ProfileItem>((item) {
      return ProfileItem.fromJson(item);
    }).toList();
  }
}

class ProfileItem {
  late String id;
  late String name;
  late String avatar;

  ProfileItem.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    avatar = json["avatar"];
  }
}
