import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {

  Future<SharedPreferences> _sharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  updateTransactionFormDisplay(String formDisplay) async {
    final prefs = await _sharedPreferences();
    await prefs.setString('formDisplay', formDisplay);
  }

  Future<String?> getTransactionFormDisplay() async {
    final prefs = await _sharedPreferences();
    final formDisplay = prefs.getString("formDisplay");
    return formDisplay;
  }
}
