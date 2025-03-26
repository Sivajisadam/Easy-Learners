import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:io';
import 'common_imports.dart';

class HiveStorage {
  static const String userBox = 'userBox';
  static const String settingsBox = 'settingsBox';
  static const String assistantBox = 'assistant_box';

  static Future<void> init() async {
    final Directory appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    await Hive.openBox(userBox);
    await Hive.openBox(settingsBox);
    await Hive.openBox(assistantBox);
  }

  static Future<void> saveData(
      {required String boxName,
      required String key,
      required dynamic value}) async {
    final box = await Hive.openBox(boxName);
    await box.put(key, value);
  }

  static dynamic getData({required String boxName, required String key}) {
    final box = Hive.box(boxName);
    return box.get(key);
  }

  static bool hasData({required String boxName, required String key}) {
    final box = Hive.box(boxName);
    return box.containsKey(key);
  }

  static Future<void> deleteData(
      {required String boxName, required String key}) async {
    final box = Hive.box(boxName);
    await box.delete(key);
  }

  static Future<void> clearBox({required String boxName}) async {
    final box = Hive.box(boxName);
    await box.clear();
  }

  static Future<void> closeBoxes() async {
    await Hive.close();
  }
}
