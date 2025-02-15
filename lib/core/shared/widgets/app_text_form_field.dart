import 'package:flutter/material.dart';

class AppTextFileld extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? hint;
  final Widget? suffixWidget;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextInputType? textInputType;

  const AppTextFileld({
    super.key,
    required this.controller,
    this.validator,
    required this.hint,
    this.suffixWidget,
    this.prefixIcon,
    this.obscureText = false,
    this.textInputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixWidget,
        hintText: hint,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: buildBorderTextField(Colors.indigo),
        focusedBorder: buildBorderTextField(Color(0xff2865DC)),
        errorBorder: buildBorderTextField(Colors.red),
        focusedErrorBorder: buildBorderTextField(Colors.red),
      ),
      keyboardType: textInputType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      textInputAction: TextInputAction.next,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
    );
  }

  OutlineInputBorder buildBorderTextField(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color),
    );
  }
}
