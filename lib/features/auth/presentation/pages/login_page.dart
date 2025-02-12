import 'package:flutter/material.dart';
import 'package:ping/core/shared/widgets/app_button.dart';
import 'package:ping/features/auth/presentation/pages/sign_up.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void trySubmit() {
      if (_formKey.currentState!.validate()) {
        FocusScope.of(context).unfocus();
      }
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/splash-logo.png",
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val!.isEmpty || !val.contains("@")) {
                        return "Please enter correct email";
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    controller: emailcontroller,
                    decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email_outlined)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    validator: (val) {
                      if (val!.isEmpty || val.length < 6) {
                        return "Please enter more than 6 digits";
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    controller: passwordcontroller,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock_clock_outlined)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  AppButton(
                    onPressed: trySubmit,
                    child: const Text("Login"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ));
                          },
                          child: const Text("Register"))
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
