import 'package:ping/core/services/remote_database_service.dart';
import 'package:ping/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDatabaseSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel> getUser(String userId);
}

class AuthRemoteDatabaseSourceImpl implements AuthRemoteDatabaseSource {
  final RemoteDatabaseService remoteDatabaseService;

  AuthRemoteDatabaseSourceImpl({required this.remoteDatabaseService});
  @override
  Future<UserModel> getUser(String userId) {
    return remoteDatabaseService.get(
        '/users/$userId', (data) => UserModel.fromJson(data));
  }

  @override
  Future<void> saveUser(UserModel user) {
    return remoteDatabaseService.set(
        '/users/${user.uId}', user, (user) => user.toJson());
  }
}
