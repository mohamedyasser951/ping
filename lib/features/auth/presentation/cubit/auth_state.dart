part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, success, error }

class AuthState {
  final AuthStatus authStatus;
  final UserModel? user;
  final String? errorMessage;

  AuthState({
    this.authStatus = AuthStatus.initial,
    this.user,
    this.errorMessage = '',
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() =>
      'AuthState(authStatus: $authStatus, user: ${user?.toString() ?? ''}, errorMessage: $errorMessage)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          runtimeType == other.runtimeType &&
          authStatus == other.authStatus &&
          user == other.user &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode =>
      authStatus.hashCode ^ user.hashCode ^ errorMessage.hashCode;
}
