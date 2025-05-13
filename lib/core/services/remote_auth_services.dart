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
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await firebaseAuth.currentUser!.updateDisplayName(name);
    await firebaseAuth.currentUser!.reload();
    if (credential.user == null) {
      throw Exception('Invalid user');
    }
    await credential.user!.updateDisplayName(name);
    await credential.user!.reload();

    FirebaseAuthUserAdapter firebaseAuthUserAdapter = FirebaseAuthUserAdapter();
    return firebaseAuthUserAdapter.adapt(firebaseAuth.currentUser!);
    return firebaseAuthUserAdapter.adapt(firebaseAuth.currentUser!);
  }

  @override
  Future<void> signOut() async {
    return await firebaseAuth.signOut();
  }
}

class FirebaseAuthUserAdapter {
  UserModel adapt(User user) {
    return UserModel(
        name: user.displayName ?? 'name',
        email: user.email,
        phone: user.phoneNumber,
        uId: user.uid);
  }
}
