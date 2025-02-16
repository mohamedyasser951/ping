import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/features/Chats/data/models/chat_user_model.dart';
import 'package:ping/features/Chats/data/repositories/chat_repo_implm.dart';
part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  FirebaseChatRepositoryImplem chatsRepo = FirebaseChatRepositoryImplem();
  ChatsCubit() : super(ChatsInitial());

  Future<void> getChats(String userId) async {
    emit(ChatsLoading());
    final result = await chatsRepo.getChats(userId);
    result.fold(
      (failure) => emit(ChatsError(message: failure.message)),
      (users) => emit(ChatsSuccess(users: users)),
    );
  }
}
