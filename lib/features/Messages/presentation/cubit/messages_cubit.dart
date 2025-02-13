import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/features/Messages/data/datasources/firebase_message_service.dart';
import 'package:ping/features/Messages/data/models/message_model.dart';
part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  final FirebaseMessageRepository _firebaseMessageRepository;

  MessagesCubit({
    required FirebaseMessageRepository firebaseMessageRepository,
  })  : _firebaseMessageRepository = firebaseMessageRepository,
        super(MessagesState());

  Future<void> sendMessage(MessageModel message) async {
    emit(state.copyWith(status: MessageStatus.messageSentLoading));
    final response = await _firebaseMessageRepository.sendMessage(message);
    response.fold(
      (failure) => emit(state.copyWith(
          status: MessageStatus.messageSentError,
          errorMessage: failure.message)),
      (r) => emit(state.copyWith(
        status: MessageStatus.messageSentSuccess,
      )),
    );
  }

  Stream<void> getMessages(String userId, String peerId) async* {
    emit(state.copyWith(status: MessageStatus.messagesLoading));
    yield* _firebaseMessageRepository.getMessages(userId, peerId).map(
          (response) => response.fold(
            (failure) => state.copyWith(
                status: MessageStatus.messagesError,
                errorMessage: failure.message),
            (messages) => state.copyWith(
              status: MessageStatus.messagesSuccess,
              messages: messages,
            ),
          ),
        );
  }
}


  // String _mapFailureToMessage(Failure failure) {
  //   if (failure is ServerFailure) return "Server Error: ${failure.message}";
  //   if (failure is NetworkFailure) return "Check your internet connection.";
  //   if (failure is CacheFailure) return "Failed to fetch cached messages.";
  //   return "Unexpected error occurred.";
  // }