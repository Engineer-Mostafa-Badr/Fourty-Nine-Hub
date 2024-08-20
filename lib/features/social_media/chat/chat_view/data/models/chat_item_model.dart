class ChatItemModel {
  List<ChatModel>? chats;
  int? totalUnread;

  ChatItemModel({this.chats, this.totalUnread});

  ChatItemModel.fromJson(Map<String, dynamic> json) {
    if (json['chats'] != null) {
      chats = <ChatModel>[];
      json['chats'].forEach((v) {
        chats!.add(ChatModel.fromJson(v));
      });
    }
    totalUnread = json['totalUnread'];
  }
}

class ChatModel {
  String? sId;
  String? lastMessageText;
  String? name;
  String? avatar;
  bool? muted;
  bool? seen;
  bool? archived;
  bool? locked;
  bool? typing;
  bool? online;
  int? lastSeenCount;
  int? unreadCount;
  String? userId;
  String? formattedUpdatedAt;

  ChatModel({
    this.sId,
    this.lastMessageText,
    this.muted,
    this.archived,
    this.seen,
    this.name,
    this.locked,
    this.avatar,
    this.online,
    this.lastSeenCount,
    this.unreadCount,
    this.userId,
    this.formattedUpdatedAt,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    muted = json['muted'];
    archived = json['archived'];
    seen = json['seen'];
    name = json['name'];
    avatar = json['avatar'];
    lastMessageText = json['lastMessageText'];
    lastSeenCount = json['lastSeenCount'];
    locked = json['locked'];
    unreadCount = json['unreadCount'];
    userId = json['userId'];
    formattedUpdatedAt = json['formattedUpdatedAt'];
    typing = false;
    online = false;
  }
}
