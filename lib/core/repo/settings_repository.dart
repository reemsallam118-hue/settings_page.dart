import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  Future<Map<String, Object>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'isArabic': prefs.getBool('isArabic') ?? true,
      'isDark': prefs.getBool('isDark') ?? false,
      'notificationsOn': prefs.getBool('notificationsOn') ?? true,
      'fontScale': prefs.getDouble('fontScale') ?? 1.0,
    };
  }

  Future<void> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> setDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }
}
