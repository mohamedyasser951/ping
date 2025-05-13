import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ping/features/Messages/data/models/message_model.dart';
part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit() : super(MessagesState(status: MessageStatus.initial));
}


  // String _mapFailureToMessage(Failure failure) {
  //   if (failure is ServerFailure) return "Server Error: ${failure.message}";
  //   if (failure is NetworkFailure) return "Check your internet connection.";
  //   if (failure is CacheFailure) return "Failed to fetch cached messages.";
  //   return "Unexpected error occurred.";
  // }