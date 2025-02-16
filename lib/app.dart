import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/core/di/service_locator.dart';
import 'package:ping/features/Chats/presentation/pages/chats_page.dart';
import 'package:ping/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ping/features/auth/presentation/pages/login_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthCubit>()..init()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ping',
          theme: ThemeData(
            primaryColor: Color(0xff2865DC),
          ),
          home: LoginScreen()),
    );
  }
}
