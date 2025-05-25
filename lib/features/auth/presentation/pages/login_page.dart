import 'package:flutter/material.dart';
import 'package:ping/features/auth/presentation/widgets/auth_bloc_listener.dart';
import 'package:ping/features/auth/presentation/pages/sign_up_page.dart';
import 'package:ping/features/auth/presentation/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 20,
              children: [
                AuthBlocListener(),
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
    );
  }
  }     
            
      