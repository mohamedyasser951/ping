import 'package:dartz/dartz.dart';
import 'package:ping/core/network/failure.dart';
import 'package:ping/features/Chats/data/models/chat_user_model.dart';
import 'package:ping/features/Chats/data/repositories/chats_repo.dart';

class FirebaseChatRepositoryImplem implements ChatsRepo {

  @override
  Future<Either<Failure, List<ChatUserModel>>> getChats(String userId) {
    // TODO: implement getChats
    throw UnimplementedError();
  }
  
}
