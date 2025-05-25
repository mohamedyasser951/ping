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
    await cacheService.setString(userCacheKey, user.toJson());
  }

  @override
  Future<UserModel?> getUser() async {
    final userJson = await cacheService.getString(userCacheKey);
    if (userJson == null) {
      return null;
    }
    return UserModel.fromJson(userJson);
  }
  
  @override
  Future<void> deleteUser() {
    return cacheService.remove(userCacheKey);
  }
}

