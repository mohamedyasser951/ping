import 'package:dartz/dartz.dart';
import 'package:ping/core/network/failure.dart';
import 'package:ping/features/Chats/data/datasources/firebase_chat_service.dart';
import 'package:ping/features/Chats/data/models/chat_user_model.dart';
import 'package:ping/features/Chats/data/repositories/chats_repo.dart';

class FirebaseChatRepositoryImplem implements ChatsRepo {
  final FirebaseChatService firebaseChatService;

  FirebaseChatRepositoryImplem({required this.firebaseChatService});

  @override
  Future<Either<Failure, List<ChatUserModel>>> getChats(String userId) {
    return firebaseChatService.getChatUsers(userId);
  }
}
