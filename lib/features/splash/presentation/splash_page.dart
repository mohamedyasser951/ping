import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ping/features/auth/presentation/pages/login_page.dart';
import 'package:ping/features/home/presentation/pages/home_page.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});
  static const routeName = '/SplashScreenPage';

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        Future.delayed(const Duration(seconds: 2)).then(
          (value) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => state.authStatus.isLoggedIn
                    ? const HomePage()
                    : const LoginScreen(),
              ),
            );
          },
        );
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedAlign(
                alignment: Alignment.center,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: Image.asset(
                  "assets/images/splash-logo.png",
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
