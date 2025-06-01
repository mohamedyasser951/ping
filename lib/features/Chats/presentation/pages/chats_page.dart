import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/features/Chats/presentation/controllers/chat_cubit/chat_cubit.dart';
import 'package:ping/features/Chats/presentation/widgets/chat_item.dart';
import 'package:ping/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ping/features/home/presentation/pages/search_page.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  void initState() {
    context.read<ChatsCubit>().init(context.read<AuthCubit>().state.user!.uId);
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
      body: BlocBuilder<ChatsCubit, ChatState>(builder: (context, state) {
        if (state.isInitial || state.isLoading && state.chatRooms.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.isError && state.chatRooms.isEmpty) {
          return Center(
            child: Text(state.error ?? 'Something went wrong'),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            final userId = context.read<AuthCubit>().state.user?.uId;
            if (userId != null) {
              context.read<ChatsCubit>().init(userId);
            }
          },
          child: ListView.separated(
            padding: EdgeInsets.all(16.0),
            itemCount: state.chatRooms.length + (state.hasMore ? 1 : 0),
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              if (index == state.chatRooms.length) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return const SizedBox();
              }

              final room = state.chatRooms[index];
              return ChatItem(room: room);
            },
          ),
        );
      }),
    );
  }
}
