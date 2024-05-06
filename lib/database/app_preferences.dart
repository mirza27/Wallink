import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String isFirstTimeKey = 'isFirstTime';
  static const String isExpandedKey = 'isExpanded';
  static const String lastCategoryKey = 'lastCategory';
  static const String isaAlwaysAsk = 'isaAlwaysAsk';

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
    return prefs.getBool(isExpandedKey) ?? false;
  }

  static Future<void> setExpanded(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isExpandedKey, value);
  }

  // cek apakah pengecekan konfirmasi
  static Future<bool> isAlwaysAsk() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isaAlwaysAsk) ?? true;
  }

  static Future<void> setAlwaysAsk(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isaAlwaysAsk, value);
  }

  // get last category selected
  static Future<int> getLastCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(lastCategoryKey) ?? 0;
  }

  static Future<void> setLastCategory(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(lastCategoryKey, value);
  }
}
