import 'package:ping/features/Chats/data/datasources/chats_remote_data_source.dart';
import 'package:ping/features/Chats/data/models/chat_message.dart';
import 'package:ping/features/Chats/data/models/chat_room.dart';
import 'package:ping/features/Chats/data/repositories/chats_repo.dart';
import 'package:ping/features/auth/data/models/user_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _chatRemoteDataSource;

  ChatRepositoryImpl({
    required ChatRemoteDataSource chatRemoteDataSource,
  }) : _chatRemoteDataSource = chatRemoteDataSource;

  @override
  Stream<List<ChatRoom>> getChatRooms(String userId) {
    return _chatRemoteDataSource.getChatRooms(userId);
  }

  @override
  Future<List<ChatRoom>> getChatRoomsPaginated(String userId,
      {int limit = 20, String? lastRoomId}) async {
    return _chatRemoteDataSource.getChatRoomsPaginated(userId,
        limit: limit, lastRoomId: lastRoomId);
  }

  @override
  Stream<List<ChatMessage>> listenToChatMessages(String roomId) {
    return _chatRemoteDataSource.listenToChatMessages(roomId);
  }

  @override
  Future<List<ChatMessage>> getChatMessagesPaginated(String roomId,
      {int limit = 20, String? lastMessageId}) async {
    return _chatRemoteDataSource.getChatMessagesPaginated(roomId,
        limit: limit, lastMessageId: lastMessageId);
  }

  @override
  Future<void> sendMessage(String roomId, ChatMessage message) async {
    return _chatRemoteDataSource.sendMessage(roomId, message);
  }

  @override
  Future<void> markMessageAsRead(String roomId, String messageId) async {
    return _chatRemoteDataSource.markMessageAsRead(roomId, messageId);
  }

  @override
  Future<void> updateUserOnlineStatus(String userId, bool isOnline) {
    return _chatRemoteDataSource.updateUserOnlineStatus(userId, isOnline);
  }

  @override
  Future<void> updateUserLastSeen(String userId) {
    return _chatRemoteDataSource.updateUserLastSeen(userId);
  }

  @override
  Stream<bool> getUserOnlineStatus(String userId) {
    return _chatRemoteDataSource.getUserOnlineStatus(userId);
  }

  @override
  Future<ChatRoom> createChat({
    required UserModel targetUser,
    required UserModel currentUser,
  }) {
    return _chatRemoteDataSource.createChat(
      targetUser: targetUser,
      currentUser: currentUser,
    );
  }
}
