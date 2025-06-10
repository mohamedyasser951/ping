import 'package:ping/core/services/remote_database_service.dart';
import 'package:ping/features/Chats/data/models/chat_message.dart';
import 'package:ping/features/Chats/data/models/chat_room.dart';
import 'package:ping/features/auth/data/models/user_model.dart';

abstract class ChatRemoteDataSource {
  Stream<List<ChatRoom>> getChatRooms(String userId);
  Future<List<ChatRoom>> getChatRoomsPaginated(String userId,
      {int limit = 20, String? lastRoomId});
  Stream<List<ChatMessage>> listenToChatMessages(String roomId);
  Future<List<ChatMessage>> getChatMessagesPaginated(String roomId,
      {int limit = 20, String? lastMessageId});
  Future<void> sendMessage(String roomId, ChatMessage message);
  Future<void> markMessageAsRead(String roomId, String messageId);
  Future<void> updateUserOnlineStatus(String userId, bool isOnline);
  Future<void> updateUserLastSeen(String userId);
  Stream<bool> getUserOnlineStatus(String userId);

  Future<ChatRoom> createChat(
      {required UserModel targetUser, required UserModel currentUser});
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  RemoteDatabaseService remoteDatabaseService;
  ChatRemoteDataSourceImpl({
    required this.remoteDatabaseService,
  });
  @override
  Stream<List<ChatRoom>> getChatRooms(String userId) {
    return remoteDatabaseService.watchCollection(
      'chatRooms',
      ChatRoom.fromMap,
      queryBuilder: (query) => query
          .where('participantIds', arrayContains: userId)
          .orderBy('updatedAt', descending: true),
    );
  }

  @override
  Future<ChatRoom> createChat(
      {required UserModel targetUser, required UserModel currentUser}) async {
    final chatRoomId = '${targetUser.uId}_${currentUser.uId}}';

    bool isChatExists = await checkChatExists(targetUser, currentUser);

    if (isChatExists) throw Exception('Chat already exists');

    var chatRoom = ChatRoom(
      id: chatRoomId,
      participantIds: [targetUser.uId, currentUser.uId],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      participants: {
        targetUser.uId: targetUser,
        currentUser.uId: currentUser,
      },
    );
    await remoteDatabaseService.set(
      'chatRooms/$chatRoomId',
      chatRoom,
      (chatRoom) => chatRoom.toMap(),
    );
    return chatRoom;
  }

  @override
  Future<List<ChatMessage>> getChatMessagesPaginated(String roomId,
      {int limit = 20, String? lastMessageId}) async {
    final lastDoc = lastMessageId != null
        ? await remoteDatabaseService
            .getDocument('chatRooms/$roomId/messages/$lastMessageId')
        : null;
    return remoteDatabaseService.getCollectionPaginated(
      'chatRooms/$roomId/messages',
      ChatMessage.fromMap,
      queryBuilder: (query) =>
          query.orderBy('timestamp', descending: true).limit(limit),
      startAfterDocument: lastDoc,
    );
  }

  @override
  Future<List<ChatRoom>> getChatRoomsPaginated(String userId,
      {int limit = 20, String? lastRoomId}) async {
    final lastDoc = lastRoomId != null
        ? await remoteDatabaseService.getDocument('chatRooms/$lastRoomId')
        : null;

    return remoteDatabaseService.getCollectionPaginated(
      'chatRooms',
      ChatRoom.fromMap,
      queryBuilder: (query) => query
          .where('participantIds', arrayContains: userId)
          .orderBy('updatedAt', descending: true)
          .limit(limit),
      startAfterDocument: lastDoc,
    );
  }

  @override
  Stream<bool> getUserOnlineStatus(String userId) {
    return remoteDatabaseService
        .watchDocument('users/$userId')
        .map((data) => data?['isOnline'] ?? false);
  }

  @override
  Stream<List<ChatMessage>> listenToChatMessages(String roomId) {
    return remoteDatabaseService.watchCollection(
      'chatRooms/$roomId/messages',
      ChatMessage.fromMap,
      queryBuilder: (query) => query.orderBy('timestamp', descending: true),
    );
  }

  @override
  Future<void> markMessageAsRead(String roomId, String messageId) {
    throw UnimplementedError();
  }

  @override
  Future<void> sendMessage(String roomId, ChatMessage message) async {
    await remoteDatabaseService.set(
      'chatRooms/$roomId/messages/${message.id}',
      message,
      (message) => message.toMap(),
    );

    await remoteDatabaseService.update(
      'chatRooms/$roomId',
      {
        'lastMessage': message.toMap(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );
  }

  @override
  Future<void> updateUserLastSeen(String userId) {
    return remoteDatabaseService.update('users/$userId', {
      'lastSeen': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<void> updateUserOnlineStatus(String userId, bool isOnline) {
    return remoteDatabaseService.update('users/$userId', {
      'isOnline': isOnline,
      'lastSeen': DateTime.now().toIso8601String(),
    });
  }

  Future<bool> checkChatExists(
      UserModel targetUser, UserModel currentUser) async {
    final chatRoom = await remoteDatabaseService.getCollectionPaginated(
      'chatRooms',
      ChatRoom.fromMap,
      queryBuilder: (query) => query.where('participantIds',
          arrayContains: [targetUser.uId, currentUser.uId]),
    );

    return chatRoom.isNotEmpty;
  }
}
