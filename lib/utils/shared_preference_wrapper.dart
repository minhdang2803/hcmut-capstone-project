import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesWrapper {
  static final SharedPreferencesWrapper instance = SharedPreferencesWrapper._internal();
  SharedPreferencesWrapper._internal();

  Future set(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future get(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  Future setDouble(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  Future setBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<bool> getBool(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final val = prefs.getBool(key);
      return val ?? false;
    } catch (e) {
      return false;
    }
  }

  Future remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
