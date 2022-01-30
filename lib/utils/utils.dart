import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static Future<void> setFcmId(String fcmId) async {
    var pref = await SharedPreferences.getInstance();
    await pref.setString(fcmId, fcmId);
  }

  static Future<String?> getFcmId(String fcmId) async {
    return (await SharedPreferences.getInstance()).getString(fcmId) ?? null;
  }
}
