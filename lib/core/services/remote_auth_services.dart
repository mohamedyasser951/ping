import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ping/features/auth/data/models/user_model.dart';

abstract class RemoteAuthServices {
  Future<UserModel> login({required String email, required String password});
  Future<(UserModel user , bool isNewUser)> googleSignIn();

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

  @override
  Future<(UserModel user , bool isNewUser)> googleSignIn() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final userCredential = await firebaseAuth.signInWithCredential(credential);
    if (userCredential.user == null) {
      throw Exception('User not found');
    }
    FirebaseAuthUserAdapter firebaseAuthUserAdapter = FirebaseAuthUserAdapter();
    final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
    return (firebaseAuthUserAdapter.adapt(userCredential.user!), isNewUser);
  }
}

class FirebaseAuthUserAdapter {
  UserModel adapt(User user) {
    return UserModel(
      name: user.displayName ?? '',
      email: user.email ?? '',
      phone: user.phoneNumber ?? '',
      uId: user.uid,
    );
  }
}
