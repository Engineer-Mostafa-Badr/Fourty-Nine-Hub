class ChatItemModel {
  String? sId;
  String? lastMessageText;
  String? name;
  String? avatar;
  bool? muted;
  bool? seen;
  bool? archived;
  bool? locked;
  int? lastSeenCount;

  ChatItemModel({
    this.sId,
    this.lastMessageText,
    this.muted,
    this.archived,
    this.seen,
    this.name,
    this.locked,
    this.avatar,
    this.lastSeenCount,
  });

  ChatItemModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    muted = json['muted'];
    archived = json['archived'];
    seen = json['seen'];
    name = json['name'];
    avatar = json['avatar'];
    lastMessageText = json['lastMessageText'];
    lastSeenCount = json['lastSeenCount'];
    locked = json['locked'];
  }
}
