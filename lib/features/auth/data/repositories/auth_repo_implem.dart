import 'package:ping/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ping/features/auth/data/repositories/auth_repo.dart';

class AuthRepoImplem implements AuthRepo {
  final AuthRemoteDataSource authRemoteDataSource;
  AuthRepoImplem({required this.authRemoteDataSource});

  @override
  Future<void> login({required String email, required String password}) {
    return authRemoteDataSource.login(email: email, password: password);
  }

  @override
  Future<void> signup(
      {required String name, required String email, required String password}) {
    return authRemoteDataSource.signup(
        name: name, email: email, password: password);
  }

  @override
  Future<void> signOut() {
    return authRemoteDataSource.signout();
  }
}
