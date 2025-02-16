import 'dart:convert';

import 'package:ping/core/services/cache_service.dart';
import 'package:ping/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);

  Future<UserModel?> getUser();
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
    if (userJson == null) {
      return null;
    }
    return UserModel.fromJson(Map<String, dynamic>.from(jsonDecode(userJson)));
  }
}
