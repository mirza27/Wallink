import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String isFirstTimeKey = 'isFirstTime';
  static const String isExpandedKey = 'isExpanded';
  static const String lastCategoryKey = 'lastCategory';
  static const String isAlwaysAsk = 'isAlwaysAsk';
  static const String userId = 'userId';

  // value apakah pertama kali
  static Future<bool> isFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isFirstTimeKey) ?? true;
  }

  static Future<void> setFirstTime(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isFirstTimeKey, value);
  }

  // apakah expasion tile dibuka atau tutup
  static Future<bool> isExpanded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isExpandedKey) ?? true;
  }

  static Future<void> setExpanded(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isExpandedKey, value);
  }

  // cek apakah pengecekan konfirmasi
  static Future<bool> getAlwaysAsk() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isAlwaysAsk) ?? true;
  }

  static Future<void> setAlwaysAsk(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isAlwaysAsk, value);
  }

  // get last category selected
  static Future<int> getLastCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(lastCategoryKey) ?? 1;
  }

  static Future<void> setLastCategory(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(lastCategoryKey, value);
  }

  // get user id
  static Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userId) ?? '';
  }

  // set user id
  static Future<void> setUserId(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userId, value);
  }
}
