import 'package:flutter/material.dart';
import 'package:ping/core/shared/widgets/app_button.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController phonecontroller = TextEditingController();
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
      body: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Image.asset(
                      "assets/images/splash-logo.png",
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                              radius: 40,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 25,
                              )),
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 10,
                            child: Icon(Icons.add),
                          )
                        ],
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      validator: (val) {
                        if (val!.isEmpty || val.length < 4) {
                          return "Please enter correct name";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      controller: namecontroller,
                      decoration: const InputDecoration(
                          labelText: "Name", prefixIcon: Icon(Icons.person)),
                    ),
                    const SizedBox(
                      height: 10,
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
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      validator: (val) {
                        if (val!.isEmpty || val.length < 11) {
                          return "Please enter more than 11 number";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      controller: phonecontroller,
                      decoration: const InputDecoration(
                          labelText: "Phone",
                          prefixIcon: Icon(Icons.phone_android_outlined)),
                    ),
                    const SizedBox(
                      height: 10,
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
                      child: Text(
                        "Register",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                              ));
                            },
                            child: const Text("Login"))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
