part of 'messages_cubit.dart';

enum MessageStatus {
  initial,

  messagesLoading,
  messagesSuccess,
  messagesError,

  messageSentLoading,
  messageSentSuccess,
  messageSentError,
}

class MessagesState {
  final MessageStatus status;
  final List<MessageModel> messages;
  final String? errorMessage;

  const MessagesState({
    this.status = MessageStatus.initial,
    this.messages = const [],
    this.errorMessage,
  });

  MessagesState copyWith({
    MessageStatus? status,
    List<MessageModel>? messages,
    String? errorMessage,
  }) =>
      MessagesState(
        status: status ?? this.status,
        messages: messages ?? this.messages,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}

