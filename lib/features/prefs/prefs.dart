import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static SharedPreferences? _prefs;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  //sets
  static Future<bool> setString(String key, String value) async =>
      await _prefs!.setString(key, value);

  //gets
  static String? getString(String key) {
    return _prefs!.getString(key);
  }

  //deletes..
  static Future<bool> remove(String key) async => await _prefs!.remove(key);

  static Future<bool> clear() async => await _prefs!.clear();
}
