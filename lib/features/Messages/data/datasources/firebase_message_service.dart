import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dartz/dartz.dart';
import 'package:ping/core/network/failure.dart';
import 'package:ping/features/Messages/data/models/message_model.dart';
import 'package:ping/features/Messages/data/repositories/Message_repo.dart';

class FirebaseMessageRepository implements MessageRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<Either<Failure, Unit>> sendMessage(MessageModel message) async {
    try {
      final docRef = _firestore
          .collection("Messages")
          .doc(_getMessageId(message.sendId, message.receiverId))
          .collection("messages")
          .doc();

      await docRef.set({
        "sendId": message.sendId,
        "receiverId": message.receiverId,
        "text": message.text,
        "time": message.time,
        "messageType": message.messageType.name,
        "isRead": message.isRead,
        "replyTo": message.replyTo,
        "attachments": message.attachments,
        "extraData": message.extraData,
      });

      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure("Failed to send message: ${e.toString()}"));
    }
  }

  @override
  Stream<Either<Failure, List<MessageModel>>> getMessages(
      String userId, String peerId) async* {
    try {
      yield* _firestore
          .collection("Messages")
          .doc(_getMessageId(userId, peerId))
          .collection("messages")
          .orderBy("time", descending: false)
          .snapshots()
          .map((snapshot) => Right(snapshot.docs.map((doc) {
                return MessageModel(
                  sendId: doc["sendId"],
                  receiverId: doc["receiverId"],
                  text: doc["text"],
                  time: doc["time"],
                  messageType: _parseMessageType(doc["messageType"]),
                  isRead: doc["isRead"] ?? false,
                  replyTo: doc["replyTo"],
                  attachments: (doc["attachments"] as List?)
                      ?.map((e) => e.toString())
                      .toList(),
                  extraData: doc["extraData"],
                );
              }).toList()));
    } catch (e) {
      yield Left(ServerFailure("Failed to fetch messages: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, String?>> uploadMedia(
      String filePath, String fileType) async {
    try {
      String fileName = "${DateTime.now().millisecondsSinceEpoch}.$fileType";
      Reference ref = _storage.ref().child("uploads/$fileName");
      UploadTask uploadTask = ref.putFile(File(filePath));
      TaskSnapshot snapshot = await uploadTask;
      return Right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return Left(ServerFailure("Failed to upload media: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, Unit>> markMessageAsRead(
      String MessageId, String messageId) async {
    try {
      await _firestore
          .collection("Messages")
          .doc(MessageId)
          .collection("messages")
          .doc(messageId)
          .update({"isRead": true});
      return const Right(unit);
    } catch (e) {
      return Left(
          ServerFailure("Failed to mark message as read: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMessage(
      String MessageId, String messageId) async {
    try {
      await _firestore
          .collection("Messages")
          .doc(MessageId)
          .collection("messages")
          .doc(messageId)
          .delete();
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure("Failed to delete message: ${e.toString()}"));
    }
  }

  /// Helper: Generate unique Message ID
  String _getMessageId(String userId1, String userId2) {
    return (userId1.hashCode <= userId2.hashCode)
        ? "${userId1}_$userId2"
        : "${userId2}_$userId1";
  }

  /// Helper: Parse message type
  MessageType _parseMessageType(String type) {
    return MessageType.values
        .firstWhere((e) => e.name == type, orElse: () => MessageType.text);
  }
}
