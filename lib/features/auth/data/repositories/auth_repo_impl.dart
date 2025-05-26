import 'package:ping/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:ping/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ping/features/auth/data/datasources/auth_remote_database_source.dart';
import 'package:ping/features/auth/data/models/user_model.dart';
import 'package:ping/features/auth/data/repositories/auth_repo.dart';

class AuthRepoImplem implements AuthRepo {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;
  final AuthRemoteDatabaseSource authRemoteDatabaseSource;

  AuthRepoImplem({
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
    required this.authRemoteDatabaseSource,
  });

  @override
  Future<UserModel> login(
      {required String email, required String password}) async {
    final userCredential =
        await authRemoteDataSource.login(email: email, password: password);
    authLocalDataSource.saveUser(userCredential);
    final user = await authRemoteDatabaseSource.getUser(userCredential.uId!);
    return user;
  }

  @override
  Future<UserModel> signup(
      {required String name,
      required String email,
      required String password}) async {
    final userModel = await authRemoteDataSource.signup(
        name: name, email: email, password: password);
    authLocalDataSource.saveUser(userModel);
    authRemoteDatabaseSource.saveUser(userModel);
    return userModel;
  }

  @override
  Future<void> signOut() async {
     Future.wait([
      authRemoteDataSource.signout(),
      authLocalDataSource.deleteUser(),
    ]);
  }

  @override
  Future<UserModel?> getUser() async {
    return await authLocalDataSource.getUser();
  }
}
