part of 'chats_cubit.dart';

class ChatsState {
  const ChatsState();
}

class ChatsInitial extends ChatsState {}

class ChatsLoading extends ChatsState {}

class ChatsSuccess extends ChatsState {
  final List<ChatUserModel> users;

  ChatsSuccess({required this.users});
}

class ChatsError extends ChatsState {
  final String message;

  ChatsError({required this.message});
}
