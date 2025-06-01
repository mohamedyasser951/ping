import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/features/Chats/data/models/chat_room.dart';
import 'package:ping/features/Chats/presentation/controllers/chat_cubit/chat_cubit.dart';
import 'package:ping/features/auth/presentation/cubit/auth_cubit.dart';

class ChatItem extends StatelessWidget {
  final ChatRoom room;
  const ChatItem({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthCubit>().state.user;
    final currentUserId = currentUser?.uId;
    if (currentUserId == null) return const SizedBox();
    final otherParticipantId =
        room.participantIds.firstWhere((id) => id != currentUserId);
    final otherParticipant = room.participants[otherParticipantId];
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherParticipant!.name,
                  ),
                  Text(
                    room.lastMessage?.content ?? '',
                  ),
                ],
              ),
              const Spacer(),
              Text(
                room.lastMessage?.timestamp.toString() ?? '',
              ),
            ]),
          ),
        );
      },
    );
  }
}
