import 'package:flutter/material.dart';
import 'package:ping/core/shared/widgets/app_button.dart';
import 'package:ping/core/shared/widgets/app_text_form_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  void trySubmit() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextFileld(
                controller: _emailController,
                validator: (value) {
                  return null;
                },
                textInputType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
                hint: "Email",
              ),
              AppTextFileld(
                  controller: _passwordController,
                  hint: "Password",
                  obscureText: true,
                  textInputType: TextInputType.visiblePassword,
                  prefixIcon: Icons.lock_outline,
                  suffixWidget:
                      IconButton(onPressed: null, icon: Icon(Icons.visibility)),
                  validator: (value) {
                    return null;
                  }),
              AppButton(
                buttoncolor: Color(0xff2865DC),
                onPressed: trySubmit,
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )
            ]));
  }
}
