import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/features/Chats/data/models/chat_room.dart';
import 'package:ping/features/Chats/presentation/pages/chat_room_page.dart';
import 'package:ping/features/home/presentation/controller/chat_cubit/chat_cubit.dart';
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
        return ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: CircleAvatar(
            child: Text(otherParticipant!.name[0].toUpperCase()),
          ),
          title: Row(
            spacing: 6,
            children: [
              Expanded(
                child: Text(otherParticipant.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              Text(
                formatTime(room.lastMessage?.timestamp ?? DateTime.now()),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          subtitle: Row(
            spacing: 6,
            children: [
              Icon(
                Icons.done_all_outlined,
                color: room.lastMessage!.isRead ? Colors.blue : Colors.grey,
                size: 18,
              ),
              Text(
                room.lastMessage?.content ?? 'No messages yet',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
          // trailing: Text(
          //   formatTime(room.lastMessage?.timestamp ?? DateTime.now()),
          //   style: const TextStyle(fontSize: 12),
          // ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatRoomPage(
                  room: room,
                  otherParticipant: otherParticipant,
                  currentUser: currentUser!,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
