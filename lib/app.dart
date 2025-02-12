import 'package:flutter/material.dart';
import 'package:ping/features/auth/presentation/pages/login_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xff2865DC),
      ),
      home: LoginScreen(),
    );
  }
}
