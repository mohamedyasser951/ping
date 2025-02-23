import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/features/auth/data/models/user_model.dart';
import 'package:ping/features/auth/data/repositories/auth_repo.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AuthCubit({required this.authRepo}) : super(AuthState());

  void init() async {
    final user = await authRepo.getUser();
    log("init");
    log("user:$user");
    if (user == null) {
      emit(state.copyWith(authStatus: AuthStatus.loggedOut));
    } else {
      emit(state.copyWith(authStatus: AuthStatus.loggedIn, user: user));
    }
  }

  void login({required String email, required String password}) async {
    emit(state.copyWith(authStatus: AuthStatus.loading));
    try {
      final user = await authRepo.login(email: email, password: password);
      emit(state.copyWith(authStatus: AuthStatus.loggedIn, user: user));
    } catch (e) {
      emit(state.copyWith(
          authStatus: AuthStatus.error, errorMessage: e.toString()));
    }
  }

  void signup(
      {required String name,
      required String email,
      required String password}) async {
    emit(state.copyWith(authStatus: AuthStatus.loading));
    try {
      final user =
          await authRepo.signup(name: name, email: email, password: password);
      emit(state.copyWith(authStatus: AuthStatus.loggedIn, user: user));
    } catch (e) {
      emit(state.copyWith(
          authStatus: AuthStatus.error, errorMessage: e.toString()));
    }
  }

  void signOut() async {
    try {
      await authRepo.signOut();
      emit(state.copyWith(authStatus: AuthStatus.loggedOut));
    } catch (e) {
      emit(state.copyWith(
          authStatus: AuthStatus.error, errorMessage: e.toString()));
    }
  }
}
