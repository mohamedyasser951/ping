abstract class AuthRepo {
  Future<void> login({required String email, required String password});
  Future<void> signup(
      {required String name, required String email, required String password});
  Future<void> signOut();
}
