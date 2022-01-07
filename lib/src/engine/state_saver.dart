import 'package:shared_preferences/shared_preferences.dart';

abstract class CeritaStateSaver {
  void saveState(CeritaState state);

  Future<CeritaState> loadState();
}

class SharedPrefCeritaStateSaver extends CeritaStateSaver {
  static const String _KEY_CONV_ID = "Key.ConversationId";
  static const String _KEY_DIALOG_INDEX = "Key.DialogIndex";

  @override
  Future<CeritaState> loadState() async {
    final sharedPref = await SharedPreferences.getInstance();
    final conversationId = sharedPref.getString(_KEY_CONV_ID);

    if (conversationId == null) return Future.value(EmptyState);

    return Future.value(CeritaState(conversationId, sharedPref.getInt(_KEY_DIALOG_INDEX)!));
  }

  @override
  void saveState(CeritaState state) async {
    final sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString(_KEY_CONV_ID, state.conversationId);
    sharedPref.setInt(_KEY_DIALOG_INDEX, state.dialogIndex);
  }
}

class CeritaState {
  String conversationId;
  int dialogIndex;

  CeritaState(this.conversationId, this.dialogIndex);

  Map<String, dynamic> toJson() =>
      {
        "conversationId": conversationId,
        "dialogIndex": dialogIndex
      };
}

final EmptyState = CeritaState("", -1);
