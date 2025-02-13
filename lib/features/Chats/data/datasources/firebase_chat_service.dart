import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ping/core/network/failure.dart';
import 'package:ping/features/Chats/data/models/chat_user_model.dart';


class FirebaseChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Either<Failure, List<ChatUserModel>>> getChatUsers(String userId) async {
    try {
      QuerySnapshot chatRooms = await _firestore
          .collection("chats")
          .where("participants.$userId", isGreaterThanOrEqualTo: {})
          .get();

      if (chatRooms.docs.isEmpty) return const Right([]);

      List<ChatUserModel> chatUsers = [];

      for (var doc in chatRooms.docs) {
        var chatData = doc.data() as Map<String, dynamic>;
        var unreadCount = chatData["participants"][userId]["unreadCount"] ?? 0;

        // Fetch last message
        var messagesRef = _firestore
            .collection("chats")
            .doc(doc.id)
            .collection("messages")
            .orderBy("time", descending: true)
            .limit(1);

        var lastMessageSnap = await messagesRef.get();

        if (lastMessageSnap.docs.isNotEmpty) {
          var lastMessage = lastMessageSnap.docs.first;
          String peerId = lastMessage["sendId"] == userId
              ? lastMessage["receiverId"]
              : lastMessage["sendId"];

          // Fetch user details
          var userDoc = await _firestore.collection("users").doc(peerId).get();

          if (userDoc.exists) {
            chatUsers.add(ChatUserModel(
              id: peerId,
              name: userDoc["name"],
              profileImage: userDoc["profileImage"],
              lastMessage: lastMessage["text"],
              lastMessageTime: lastMessage["time"].toDate(),
              unreadMessages: unreadCount,
            ));
          }
        }
      }

      return Right(chatUsers);
    } catch (e) {
      return Left(ServerFailure("Failed to fetch chat users: ${e.toString()}"));
    }
  }

  Future<void> markMessagesAsRead(String chatId, String userId) async {
    var chatRef = _firestore.collection("chats").doc(chatId);

    // Set unread count to 0 for the user
    await chatRef.update({"participants.$userId.unreadCount": 0});

    // Mark all messages as read
    var messagesRef = chatRef.collection("messages").where("receiverId", isEqualTo: userId);
    var messagesSnap = await messagesRef.get();

    for (var doc in messagesSnap.docs) {
      doc.reference.update({"isRead": true});
    }
  }
}
