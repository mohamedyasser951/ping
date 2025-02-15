import 'package:ping/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});

  Future<UserModel> signup(
      {required String name, required String email, required String password});

  Future<void> signout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login({required String email, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<void> signout() {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> signup(
      {required String name, required String email, required String password}) {
    throw UnimplementedError();
  }
}
