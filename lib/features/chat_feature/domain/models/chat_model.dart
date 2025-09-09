class ChatModel {
  final String id;
  final String name;
  final String lastMessage;
  final String profileImage;
  final String time;
  final bool isVerified;
  final bool isTyping;
  final int unreadCount;
  final bool isMuted;
  final bool isPinned;
  final MessageStatus messageStatus;
  final MessageType messageType;

  ChatModel({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.profileImage,
    required this.time,
    this.isVerified = false,
    this.isTyping = false,
    this.unreadCount = 0,
    this.isMuted = false,
    this.isPinned = false,
    this.messageStatus = MessageStatus.sent,
    this.messageType = MessageType.text,
  });
}

enum MessageStatus {
  sent,
  delivered,
  read,
}

enum MessageType {
  text,
  photo,
  voice,
  video,
}
