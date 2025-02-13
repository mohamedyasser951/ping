import 'package:dartz/dartz.dart';
import 'package:ping/core/network/failure.dart';
import 'package:ping/features/Messages/data/models/message_model.dart';

abstract class MessageRepo {
  Future<Either<Failure, Unit>> sendMessage(MessageModel message);
  Stream<Either<Failure, List<MessageModel>>> getMessages(
      String userId, String peerId);
  Future<Either<Failure, String?>> uploadMedia(
      String filePath, String fileType);
  Future<Either<Failure, Unit>> markMessageAsRead(
      String chatId, String messageId);
  Future<Either<Failure, Unit>> deleteMessage(String chatId, String messageId);
}
