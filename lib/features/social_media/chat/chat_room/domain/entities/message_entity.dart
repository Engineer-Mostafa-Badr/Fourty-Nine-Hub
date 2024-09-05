class MessageEntity {
  String? id;
  String? text;
  String? chatId;
  String? groupId;
  bool? seen;
  bool? delivered;
  bool? isDeleted;
  bool? isReply;
  int? type;
  int? sharesCount;
  int? likesCount;
  int? loveCount;
  int? wowCount;
  int? sadCount;
  int? angryCount;
  String? createdAt;
  String? updatedAt;
  bool? byMe;
  ReplyMessage? replyMessageId;
  String? formattedCreatedAt;

  MessageEntity({
    this.id,
    this.text,
    this.chatId,
    this.groupId,
    this.seen,
    this.delivered,
    this.isDeleted,
    this.isReply,
    this.type,
    this.sharesCount,
    this.likesCount,
    this.loveCount,
    this.wowCount,
    this.sadCount,
    this.angryCount,
    this.createdAt,
    this.updatedAt,
    this.byMe,
    this.formattedCreatedAt,
    this.replyMessageId,
  });
}

class ReplyMessage {
  String? id;
  String? text;

  ReplyMessage({this.id, this.text});
}
