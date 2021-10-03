abstract class ItemType {
  String? getText();

  String getType();

  ItemType cloneWithData(Map<String, String> data);
}
