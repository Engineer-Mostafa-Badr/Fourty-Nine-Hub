class TypingAndOnlineModel {
  String? userId;
  String? chatId;
  bool? typing;
  bool? online;

  TypingAndOnlineModel({this.userId, this.chatId, this.typing, this.online});

  TypingAndOnlineModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    chatId = json['chatId'];
    typing = json['typing'];
    online = json['online'];
  }
}
