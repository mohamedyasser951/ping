import 'package:ping/features/auth/data/repositories/auth_repo.dart';

class AuthRepoImplem implements AuthRepo {
  @override
  Future<void> login({required String email, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<void> signout() {
    throw UnimplementedError();
  }

  @override
  Future<void> signup({required String email, required String password}) {
    throw UnimplementedError();
  }
}
