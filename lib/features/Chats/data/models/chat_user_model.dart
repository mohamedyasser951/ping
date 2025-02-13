class ChatUserModel {
  final String id;
  final String name;
  final String profileImage;
  final int unreadMessages;
  final String lastMessage;
  final DateTime lastMessageTime;

  const ChatUserModel({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.unreadMessages,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatUserModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
