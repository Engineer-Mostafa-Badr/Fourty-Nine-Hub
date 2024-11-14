// class SocketMessageModel {
//   String? chatRoomId;
//   String? userId;
//   MessageItem? messageItem;

//   SocketMessageModel.fromJson(Map<String, dynamic> json) {
//     chatRoomId = json['chatRoomId'];
//     userId = json['userId'];
//     messageItem =
//         json['message'] != null ? MessageItem.fromJson(json['message']) : null;
//   }
// }

// class MessageItem {
//   String? text;
//   int? type;
//   String? chatId;

//   String? categoryId;
//   String? createdAt;

//   MessageItem({
//     this.text,
//     this.type,
//     this.chatId,
//     this.categoryId,
//     this.createdAt,
//   });

//   MessageItem.fromJson(Map<String, dynamic> json) {
//     text = json['text'];
//     type = json['type'];
//     chatId = json['chatId'];

//     categoryId = json['categoryId'];
//     createdAt = json['createdAt'];
//   }
// }
