class ProfileInfo {
  late String id;
  late String sprite;

  ProfileInfo.fromIdentifier(String identifier) {
    final items = identifier.split(":");
    id = items[0];
    sprite = items[1];
  }
}
