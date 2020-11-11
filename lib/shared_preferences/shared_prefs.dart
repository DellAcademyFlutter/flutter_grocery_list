import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs{

  static Future save(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '0';
  }
}