import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefFunction {
  static String sharedPrefLogInKey = 'IsLoggedIn';
  static String sharedPrefNameKey = 'Username';
  static String sharedPrefEmailKey = 'UserEmail';

  static Future<bool> saveSharedPrefUserData(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPrefLogInKey, isLoggedIn);
  }

  static Future<bool> saveSharedPrefUserNameData(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefNameKey, username);
  }

  static Future<bool> saveSharedPrefUserEmailData(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefEmailKey, email);
  }

  static Future<bool> getSharedPrefUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPrefLogInKey);
  }

  static Future<String> getSharedPrefUserNameData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPrefNameKey);
  }

  static Future<String> getSharedPrefUserEmailData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPrefEmailKey);
  }
}
