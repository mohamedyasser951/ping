import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CacheService {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);
  Future<void> remove(String key);
}

class CacheServiceImpl implements CacheService {
  final sharedCompleter = Completer<SharedPreferences>();

  CacheServiceImpl() {
    SharedPreferences.getInstance().then((prefs) {
      sharedCompleter.complete(prefs);
    });
  }
  @override
  Future<String?> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  @override
  Future<bool> setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  @override
  Future<void> remove(String key) async {
    SharedPreferences prefs = await sharedCompleter.future;
    await prefs.remove(key);
  }
}
