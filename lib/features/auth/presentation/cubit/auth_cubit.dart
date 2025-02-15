import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/features/auth/data/models/user_model.dart';
import 'package:ping/features/auth/data/repositories/auth_repo.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AuthCubit({required this.authRepo}) : super(AuthState());

  void login({required String email, required String password}) {
    emit(state.copyWith(authStatus: AuthStatus.loading));

    authRepo.login(email: email, password: password).then((user) {
      emit(state.copyWith(authStatus: AuthStatus.success, user: null));
    }).catchError((error) {
      emit(state.copyWith(
          authStatus: AuthStatus.error, errorMessage: error.toString()));
    });
  }

  void signup(
      {required String name, required String email, required String password}) {
    emit(state.copyWith(authStatus: AuthStatus.loading));

    authRepo.signup(name: name, email: email, password: password).then((user) {
      emit(state.copyWith(authStatus: AuthStatus.success, user: null));
    }).catchError((error) {
      emit(state.copyWith(
          authStatus: AuthStatus.error, errorMessage: error.toString()));
    });
  }
}
