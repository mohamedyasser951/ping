import 'package:firebase_auth/firebase_auth.dart';
import 'package:ping/features/auth/data/models/user_model.dart';

abstract class RemoteAuthServices {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> signup(
      {required String name, required String email, required String password});
  Future<void> signOut();
}

class RemoteAuthServicesImpl implements RemoteAuthServices {
  FirebaseAuth firebaseAuth;
  RemoteAuthServicesImpl({required this.firebaseAuth});
  @override
  Future<UserModel> login(
      {required String email, required String password}) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    if (credential.user == null) {
      throw Exception('User not found');
    }
    FirebaseAuthUserAdapter firebaseAuthUserAdapter = FirebaseAuthUserAdapter();
    return firebaseAuthUserAdapter.adapt(credential.user!);
  }

  @override
  Future<UserModel> signup(
      {required String name,
      required String email,
      required String password}) async {
    final firebaseUser = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await firebaseUser.user!.updateDisplayName(name);
    await firebaseUser.user!.reload();

    if (firebaseUser.user == null) {
      throw Exception('Invalid user');
    }
    final firebaseAuthUserAdapter = FirebaseAuthUserAdapter();
    return firebaseAuthUserAdapter.adapt(firebaseAuth.currentUser!);
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}

class FirebaseAuthUserAdapter {
  UserModel adapt(User user) {
    return UserModel(
        name: user.displayName!,
        email: user.email,
        phone: user.phoneNumber,
        uId: user.uid);
  }
}
