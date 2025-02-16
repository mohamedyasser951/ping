import 'package:ping/features/Chats/data/models/chat_user_model.dart';

abstract class ChatsRemoteDataSource {
  Future<List<ChatUserModel>> getChats();
}


