import 'package:shared_preferences/shared_preferences.dart';

class DBHelper {
  // Retorna a instância global do SharedPreferences
  static Future<SharedPreferences> get prefs async {
    return await SharedPreferences.getInstance();
  }
}
