import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ping/features/auth/data/models/user_model.dart';
import 'package:ping/features/auth/data/repositories/auth_repo.dart';
import 'package:ping/features/auth/presentation/cubit/auth_cubit.dart';

class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  group('AuthCubit', () {
    late AuthCubit cubit;
    late MockAuthRepo mockAuthRepo;

    setUp(() {
      mockAuthRepo = MockAuthRepo();
      cubit = AuthCubit(authRepo: mockAuthRepo);
    });

    tearDown(() {
      cubit.close();
    });

    group('Login Functiona', () {
      blocTest<AuthCubit, AuthState>(
        'emits Loading and Success when login is successful',
        build: () => cubit,
        setUp: () =>
            when(() => mockAuthRepo.login(email: 'email', password: 'password'))
                .thenAnswer((_) async => UserModel(
                    name: 'name', email: 'email', uId: 'uId', phone: 'phone')),
        act: (cubit) => cubit.login(email: 'email', password: 'password'),
        expect: () => [
          AuthState(authStatus: AuthStatus.loading),
          AuthState(
              authStatus: AuthStatus.loggedIn,
              user: UserModel(
                  name: 'name', email: 'email', uId: 'uId', phone: 'phone')),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits Loading and Error when login fails',
        build: () => cubit,
        setUp: () =>
            when(() => mockAuthRepo.login(email: "email", password: "password"))
                .thenAnswer((_) async => throw Exception('Login failed')),
        act: (cubit) => cubit.login(email: 'email', password: 'password'),
        expect: () => [
          AuthState(authStatus: AuthStatus.loading),
          AuthState(
              authStatus: AuthStatus.error,
              errorMessage: 'Exception: Login failed'),
        ],
      );
    });

    group('Signup Functiona', () {
      blocTest<AuthCubit, AuthState>(
        'emits Loading and Success when signup is successful',
        build: () => cubit,
        setUp: () => when(() => mockAuthRepo.signup(
                name: 'name', email: 'email', password: 'password'))
            .thenAnswer((_) async => UserModel(
                name: 'name', email: 'email', uId: 'uId', phone: 'phone')),
        act: (cubit) =>
            cubit.signup(name: 'name', email: 'email', password: 'password'),
        expect: () => [
          AuthState(authStatus: AuthStatus.loading),
          AuthState(
              authStatus: AuthStatus.loggedIn,
              user: UserModel(
                  name: 'name', email: 'email', uId: 'uId', phone: 'phone')),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits Loading and Error when signup fails',
        build: () => cubit,
        setUp: () => when(() => mockAuthRepo.signup(
                name: 'name', email: 'email', password: 'password'))
            .thenAnswer((_) async => throw Exception('Signup failed')),
        act: (cubit) =>
            cubit.signup(name: 'name', email: 'email', password: 'password'),
        expect: () => [
          AuthState(authStatus: AuthStatus.loading),
          AuthState(
              authStatus: AuthStatus.error,
              errorMessage: 'Exception: Signup failed'),
        ],
      );
    });
  });
}

/*
First principles of testing stand for

Fast
Isolated/Independent
Repeatable
Self-validating => you shouldn’t need to check manually, whether the test passed or not.
thorough

 */
