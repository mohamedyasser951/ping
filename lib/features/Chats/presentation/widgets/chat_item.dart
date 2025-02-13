import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/features/Chats/data/models/chat_user_model.dart';
import 'package:ping/features/Chats/presentation/cubit/chats_cubit.dart';

class ChatItem extends StatelessWidget {
  final ChatUserModel model;
  const ChatItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsCubit, ChatsState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(model.profileImage),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Text(model.name),
              const Spacer(),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert,
                    size: 20.0,
                  ))
            ]),
          ),
        );
      },
    );
  }
}
