import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/core/shared/widgets/app_button.dart';
import 'package:ping/core/shared/widgets/app_text_form_field.dart';
import 'package:ping/features/auth/presentation/cubit/auth_cubit.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  // late TextEditingController _phoneController;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  void trySubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signup(
          name: _nameController.text.trim(),
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
            controller: _nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Name is required";
              }
              return null;
            },
            textInputType: TextInputType.name,
            prefixIcon: Icons.person,
            hint: "Name",
          ),
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

          // AppTextFileld(
          //   controller: _phoneController,
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return "Phone is required";
          //     }
          //     return null;
          //   },
          //   textInputType: TextInputType.phone,
          //   prefixIcon: Icons.phone,
          //   hint: "Phone",
          // ),

          AppTextFileld(
              controller: _passwordController,
              hint: "Password",
              obscureText: true,
              textInputType: TextInputType.visiblePassword,
              prefixIcon: Icons.lock_outline,
              suffixWidget:
                  IconButton(onPressed: null, icon: Icon(Icons.visibility)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password is required";
                }
                return null;
              }),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return AppButton(
                buttoncolor: Color(0xff2865DC),
                onPressed: trySubmit,
                child: state.authStatus.isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
