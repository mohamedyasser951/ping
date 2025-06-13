import 'package:ping/features/auth/data/models/user_model.dart';

abstract class AuthRepo {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> googleSignIn();
  Future<UserModel> signup(
      {required String name, required String email, required String password});
  Future<void> signOut();
  Future<UserModel?> getUser();
}
