import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/features/Chats/presentation/controllers/chat_cubit/chat_cubit.dart';
import 'package:ping/features/auth/data/models/user_model.dart';

class ChatItem extends StatelessWidget {
  final UserModel model;
  const ChatItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsCubit, ChatState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              CircleAvatar(
                radius: 25.0,
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
