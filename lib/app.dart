import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/core/di/service_locator.dart';
import 'package:ping/features/Chats/presentation/controllers/chat_cubit/chat_cubit.dart';
import 'package:ping/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ping/features/splash/presentation/splash_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthCubit>()..init()),
        BlocProvider(create: (context) => sl<ChatsCubit>())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ping',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0xFF1E88E5),
              primary: Color(0xFF1E88E5),
              secondary: Color(0xFF1E88E5),
            ),
            useMaterial3: true,
          ),
          home: SplashScreenPage()),
    );
  }
}
