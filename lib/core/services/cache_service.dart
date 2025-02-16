import 'package:shared_preferences/shared_preferences.dart';

abstract class CacheService {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);
}

class CacheServiceImpl implements CacheService {
  final SharedPreferences prefs;

  CacheServiceImpl({
    required this.prefs,
  });

  @override
  Future<String?> getString(String key) async {
    return prefs.getString(key);
  }

  @override
  Future<void> setString(String key, String value) {
    return prefs.setString(key, value);
  }
}
