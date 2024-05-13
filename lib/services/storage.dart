import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static Future updateStorageKey(
      {required String key, required dynamic newValue}) async {
    final _prefs = await SharedPreferences.getInstance();
    final _stored = json.decode(_prefs.getString('cached_profile')!)
        as Map<String, dynamic>;
    _stored[key] = newValue;
    String _m = json.encode(_stored);
    _prefs.setString('cached_profile', _m);
  }

  static Future<Map<String, dynamic>> returnProfile() async {
    final _prefs = await SharedPreferences.getInstance();
    final _stored = json.decode(_prefs.getString('cached_profile')!)
        as Map<String, dynamic>;
    return _stored;
  }

  static Future<dynamic?> returnStoredKeyValue({required String key}) async {
    final _prefs = await SharedPreferences.getInstance();
    final _stored = json.decode(_prefs.getString('cached_profile')!)
        as Map<String, dynamic>;
    return _stored[key];
  }
}
