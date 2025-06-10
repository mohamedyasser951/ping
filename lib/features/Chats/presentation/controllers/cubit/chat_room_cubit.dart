import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/features/Chats/data/models/chat_message.dart';
import 'package:ping/features/Chats/data/repositories/chats_repo.dart';
import 'package:ping/features/auth/data/models/user_model.dart';

part 'chat_room_state.dart';

class ChatRoomCubit extends Cubit<ChatRoomState> {
  final ChatRepository _chatRepository;
  StreamSubscription<List<ChatMessage>>? _messagesSubscription;

  ChatRoomCubit({
    required ChatRepository chatRepository,
  })  : _chatRepository = chatRepository,
        super(const ChatRoomState());

  void init(String roomId) {
    emit(state.copyWith(status: ChatRoomStatus.loading, roomId: roomId));

    _messagesSubscription?.cancel();
    _messagesSubscription = _chatRepository.listenToChatMessages(roomId).listen(
      (messages) {
        emit(state.copyWith(
          status: ChatRoomStatus.loaded,
          messages: messages,
        ));
      },
      onError: (error) {
        log(error.toString());
        emit(state.copyWith(
          status: ChatRoomStatus.error,
          error: error.toString(),
        ));
      },
    );
  }

  Future<void> loadMoreMessages() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(status: ChatRoomStatus.loadingMore));

    try {
      final lastMessageId =
          state.messages.isNotEmpty ? state.messages.last.id : null;
      final moreMessages = await _chatRepository.getChatMessagesPaginated(
        state.roomId!,
        lastMessageId: lastMessageId,
      );

      if (moreMessages.isEmpty) {
        emit(state.copyWith(status: ChatRoomStatus.loaded, hasMore: false));
        return;
      }

      emit(state.copyWith(
        status: ChatRoomStatus.loaded,
        messages: [...state.messages, ...moreMessages],
      ));
    } catch (error) {
      emit(state.copyWith(
        status: ChatRoomStatus.error,
        error: error.toString(),
      ));
    }
  }

  Future<void> sendMessage({
    required String content,
    required UserModel currentUser,
    required UserModel otherUser,
  }) async {
    content = content.trim();
    if ((state.messageStatus?.isLoading ?? false) || content.isEmpty) return;

    emit(state.copyWith(messageStatus: MessageStatus.loading));

    try {
      final roomId = state.roomId!;
      final messageId = '${roomId}_${DateTime.now().millisecondsSinceEpoch}';

      final message = ChatMessage(
        id: messageId,
        senderId: currentUser.uId,
        receiverId: otherUser.uId,
        content: content,
        timestamp: DateTime.now(),
      );

      await _chatRepository.sendMessage(roomId, message);

      emit(state.copyWith(messageStatus: MessageStatus.sent));
    } catch (error) {
      emit(state.copyWith(
        error: error.toString(),
        messageStatus: MessageStatus.failed,
      ));
    }
  }

  Future<void> markMessageAsRead(String messageId) async {
    try {
      await _chatRepository.markMessageAsRead(state.roomId!, messageId);
    } catch (error) {
      emit(state.copyWith(
        error: error.toString(),
      ));
    }
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
