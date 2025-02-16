import 'package:ping/core/services/remote_auth_services.dart';
import 'package:ping/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});

  Future<UserModel> signup(
      {required String name, required String email, required String password});

  Future<void> signout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  RemoteAuthServices remoteAuthServices;
  AuthRemoteDataSourceImpl({
    required this.remoteAuthServices,
  });

  @override
  Future<UserModel> login({required String email, required String password}) {
    return remoteAuthServices.login(email: email, password: password);
  }

  @override
  Future<UserModel> signup(
      {required String name, required String email, required String password}) {
    return remoteAuthServices.signup(
        name: name, email: email, password: password);
  }

  @override
  Future<void> signout() {
    return remoteAuthServices.signOut();
  }
}
