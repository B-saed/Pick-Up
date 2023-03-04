import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DataStore {
  static const storage = FlutterSecureStorage();

  static Future<void> saveValue({required String key, required String value}) async {
    await storage.write(key: key, value: value);
  }

  static Future<String?> getValue({required String key}) async {
    return await storage.read(key: key);
  }

  static Future<void> deleteValue({required String key}) async {
    await storage.delete(key: key);
  }
}
