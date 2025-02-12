import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Widget child;
  final Color? buttoncolor;
  final VoidCallback? onPressed;
  const AppButton({
    super.key,
    required this.child,
    this.buttoncolor = Colors.indigoAccent,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttoncolor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
      child: child,
    );
  }
}
