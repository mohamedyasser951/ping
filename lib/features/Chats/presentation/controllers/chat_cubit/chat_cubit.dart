import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/features/Chats/data/models/chat_message.dart';
import 'package:ping/features/Chats/data/models/chat_room.dart';
import 'package:ping/features/Chats/data/repositories/chats_repo.dart';
import 'package:ping/features/auth/data/models/user_model.dart';
part 'chat_state.dart';

class ChatsCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;
  ChatsCubit({
    required this.chatRepository,
  }) : super(ChatState());

  Future<void> createChat({
    required UserModel targetUser,
    required UserModel currentUser,
  }) async {
    try {
      final room = await chatRepository.createChat(
        targetUser: targetUser,
        currentUser: currentUser,
      );

      emit(state.copyWith(chatRoom: room));
    } catch (error) {
      emit(state.copyWith(
        status: ChatStatus.error,
        error: error.toString(),
      ));
    }
  }
}
