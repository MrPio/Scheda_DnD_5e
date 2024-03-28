import 'package:shared_preferences/shared_preferences.dart';

class IOManager {
  static final IOManager _instance = IOManager._();

  factory IOManager() => _instance;

  IOManager._();

  setCacheData(String name, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(name, value);
  }

  Future<String?> getCacheData(String name) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(name);
  }

  removeCacheData(String name) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(name);
  }
}
