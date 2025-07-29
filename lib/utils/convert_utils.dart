import 'dart:convert';

class ConvertUtils {
  static int getInt(dynamic value, {int defaultValue = 0}) {
    if (value is int) {
      return value;
    } else if (value is double) {
      return value.toInt();
    } else if (value == null) {
      return defaultValue;
    } else {
      return int.tryParse(value.toString()) ?? defaultValue;
    }
  }

  static double getDouble(dynamic value, {double defaultValue = 0}) {
    if (value == null) {
      return defaultValue;
    } else {
      final tmp =
          (double.tryParse(value.toString()) ?? defaultValue).toString();
      return double.tryParse(tmp == '-0.00' || tmp == '-0' ? '0' : tmp) ??
          defaultValue;
    }
  }

  static String getString(dynamic value, {String defaultValue = ''}) {
    if (value is String) {
      return value;
    } else if (value == null) {
      return defaultValue;
    } else {
      return value.toString();
    }
  }

  static bool getBool(dynamic value, {bool defaultValue = false}) {
    return [true, 'true', 1, 'yes', 'TRUE', 'YES'].contains(value);
  }

  static List<T> getList<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson, {
    List<T> defaultValue = const [],
    T Function(dynamic)? getValue,
  }) {
    try {
      if (value is List) {
        return value
            .map((e) => getValue != null ? getValue(e) : fromJson(e))
            .toList();
      } else {
        return defaultValue;
      }
    } catch (e) {
      return defaultValue;
    }
  }

  static Map<String, dynamic> getMap(
    dynamic value, {
    Map<String, dynamic> defaultValue = const {},
  }) {
    if (value is Map<String, dynamic>) {
      return value;
    } else if (value is String) {
      final map = jsonDecode(jsonEncode(value));
      return map is Map<String, dynamic> ? map : defaultValue;
    } else {
      return defaultValue;
    }
  }
}
