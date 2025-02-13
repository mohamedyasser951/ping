import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/features/Chats/presentation/cubit/chats_cubit.dart';
import 'package:ping/features/Chats/presentation/widgets/chat_item.dart';

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
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: BlocBuilder<ChatsCubit, ChatsState>(
        builder: (context, state) {
          if (state is ChatsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatsError) {
            return Center(child: Text(state.message));
          } else if (state is ChatsSuccess) {
            return ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) =>
                  ChatItem(model: state.users[index]),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
