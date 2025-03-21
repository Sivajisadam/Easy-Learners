import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future writeData(String key, String value) async {
    final write = await SharedPreferences.getInstance();
    write.setString(key, value);
  }

  static Future<String?> readData(String key) async {
    final read = await SharedPreferences.getInstance();
    return read.getString(key);
  }

  static Future deleteData(String key) async {
    final delete = await SharedPreferences.getInstance();
    delete.remove(key);
  }

  static Future clearLoccalStorage() async {
    final clear = await SharedPreferences.getInstance();
    clear.clear();
  }
}
