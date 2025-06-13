import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/core/shared/widgets/app_button.dart';
import 'package:ping/core/shared/widgets/app_text_form_field.dart';
import 'package:ping/features/auth/presentation/cubit/auth_cubit.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late GlobalKey<FormState> _formKey;
  bool _obscureText = true;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  void trySubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
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
              if (value == null || value.isEmpty) {
                return "Email is required";
              }
              return null;
            },
            textInputType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            hint: "Email",
          ),
          AppTextFileld(
              controller: _passwordController,
              hint: "Password",
              obscureText: _obscureText,
              textInputType: TextInputType.visiblePassword,
              prefixIcon: Icons.lock_outline,
              suffixWidget: IconButton(
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                  icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password is required";
                }
                return null;
              }),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return Visibility(
                visible: !state.authStatus.isLoading,
                replacement: const Center(child: CircularProgressIndicator()),
                child: AppButton(
                  buttoncolor: Color(0xff2865DC),
                  onPressed: trySubmit,
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              );
            },
          ),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return Visibility(
                visible: !state.authStatus.isLoading,
                replacement: const Center(child: CircularProgressIndicator()),
                child: AppButton(
                  buttoncolor: Colors.grey,
                  onPressed: () {
                    context.read<AuthCubit>().googleSignIn();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 6,
                    children: [
                      Image.asset("assets/images/google.png", width: 30),
                      const Text(
                        "Login with Google",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
