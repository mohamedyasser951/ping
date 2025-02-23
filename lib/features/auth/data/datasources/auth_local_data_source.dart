import 'dart:convert';
import 'dart:developer';

import 'package:ping/core/services/cache_service.dart';
import 'package:ping/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);

  Future<UserModel?> getUser();

  Future<void> deleteUser() async {}
}

const userCacheKey = 'User_Cache_Key';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final CacheService cacheService;

  AuthLocalDataSourceImpl({required this.cacheService});

  @override
  Future<void> saveUser(UserModel user) async {
    await cacheService.setString(userCacheKey, user.toString());
  }

  @override
  Future<UserModel?> getUser() async {
    final userJson = await cacheService.getString(userCacheKey);
    // log("userJson:$userJson");
    if (userJson == null) {
      return null;
    }
    final user = UserModel.fromJson(jsonDecode(userJson));
    log("user:$user");
    return user;
  }

  @override
  Future<void> deleteUser() {
    return cacheService.remove(userCacheKey);
  }
}
