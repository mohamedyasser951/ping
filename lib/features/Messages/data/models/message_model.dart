import 'package:cloud_firestore/cloud_firestore.dart';

/// Enum to define message types
enum MessageType { 
  text, image, video, audio, gif, document, location, 
  sticker, poll, reaction, contact, file 
}

class MessageModel {
  final String sendId;
  final String receiverId;
  final String text;
  final Timestamp time;
  final MessageType messageType; // Now supports multiple types
  final bool isRead;
  final String? replyTo; // Message ID being replied to (if any)
  final List<String>? attachments; // List of file/image/audio/video URLs
  final Map<String, dynamic>? extraData; // Additional data for polls, reactions, etc.

  MessageModel({
    required this.sendId,
    required this.receiverId,
    required this.text,
    required this.time,
    this.messageType = MessageType.text, // Default to text
    this.isRead = false,
    this.replyTo,
    this.attachments,
    this.extraData,
  });

  /// Factory constructor to create an instance from JSON safely.
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      sendId: json["sendId"] ?? "",
      receiverId: json["receiverId"] ?? "",
      text: json["text"] ?? "",
      time: json["time"] ?? Timestamp.now(),
      messageType: _parseMessageType(json["messageType"] ?? "text"),
      isRead: json["isRead"] ?? false,
      replyTo: json["replyTo"],
      attachments: (json["attachments"] as List?)?.map((e) => e.toString()).toList(),
      extraData: json["extraData"] != null ? Map<String, dynamic>.from(json["extraData"]) : null,
    );
  }

  /// Converts the object to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      "sendId": sendId,
      "receiverId": receiverId,
      "text": text,
      "time": time,
      "messageType": messageType.name, // Store enum as a string in Firestore
      "isRead": isRead,
      "replyTo": replyTo,
      "attachments": attachments,
      "extraData": extraData,
    };
  }

  /// Helper function to parse messageType from a string
  static MessageType _parseMessageType(String type) {
    switch (type) {
      case "image": return MessageType.image;
      case "video": return MessageType.video;
      case "audio": return MessageType.audio;
      case "gif": return MessageType.gif;
      case "document": return MessageType.document;
      case "location": return MessageType.location;
      case "sticker": return MessageType.sticker;
      case "poll": return MessageType.poll;
      case "reaction": return MessageType.reaction;
      case "contact": return MessageType.contact;
      case "file": return MessageType.file;
      default: return MessageType.text;
    }
  }
}
