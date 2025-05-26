import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/features/Chats/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:ping/features/home/presentation/pages/search_page.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          "Chats",
          style: TextStyle(color: Colors.indigoAccent, fontSize: 25),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SearchPage(),
                  ),
                );
              },
              icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: BlocProvider(
        create: (context) => ChatsCubit(),
        child: BlocBuilder<ChatsCubit, ChatsState>(
          builder: (context, state) {
            return Center(child: Text("Something went wrong"));
          },
        ),
      ),
    );
  }
}
