import 'package:dartz/dartz.dart';
import 'package:ping/core/network/failure.dart';
import 'package:ping/features/Chats/data/models/chat_user_model.dart';

abstract class ChatsRepo {
  Future<Either<Failure, List<ChatUserModel>>> getChats(String userId);
}
