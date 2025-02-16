import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/features/Chats/presentation/pages/chats_page.dart';
import 'package:ping/features/auth/presentation/pages/sign_up.dart';
import 'package:ping/features/auth/presentation/widgets/login_form.dart';
import 'package:ping/features/auth/presentation/cubit/auth_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.authStatus.isLoggedIn) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text("Welcome ${state.user?.name}!"),
              ),
            );
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => ChatsScreen(),
            ));
          }
          if (state.authStatus.isError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.errorMessage ?? 'Error'),
              ),
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 20,
                children: [
                  Image.asset(
                    "assets/images/splash-logo.png",
                    width: MediaQuery.of(context).size.width * 0.6,
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  LoginForm(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ",
                          style: TextStyle(fontSize: 16)),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ));
                          },
                          child: const Text("Register",
                              style: TextStyle(fontSize: 16)))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
