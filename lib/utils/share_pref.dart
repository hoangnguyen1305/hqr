import 'package:shared_preferences/shared_preferences.dart';

class SharePref {
  static final SharePref _instance = SharePref._internal();
  SharedPreferences? _preferences;

  factory SharePref() {
    return _instance;
  }

  SharePref._internal();

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future saveString(String key, String? value) async {
    await _preferences?.setString(key, value ?? '');
  }

  String? getString(String key) {
    return _preferences?.getString(key);
  }

  Future saveDouble(String key, double? value) async {
    await _preferences?.setDouble(key, value ?? 0);
  }

  int? getInt(String key, {int? initValue}) {
    return _preferences?.getInt(key) ?? initValue;
  }

  double? getDouble(String key) {
    return _preferences?.getDouble(key);
  }

  Future saveInt(String key, int? value) async {
    await _preferences?.setInt(key, value ?? 0);
  }

  Future<dynamic>? clear() {
    return _preferences?.clear();
  }
}
