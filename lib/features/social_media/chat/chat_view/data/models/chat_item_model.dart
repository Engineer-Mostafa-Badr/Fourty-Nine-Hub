class ChatItemModel {
  String? sId;
  String? lastMessageText;
  String? name;
  String? avatar;
  bool? muted;
  bool? seen;
  bool? archived;
  int? lastSeenCount;

  ChatItemModel(
      {this.sId,
      this.lastMessageText,
      this.muted,
      this.archived,
      this.seen,
      this.name,
      this.avatar,
      this.lastSeenCount});

  ChatItemModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    muted = json['muted'];
    archived = json['archived'];
    seen = json['seen'];
    name = json['name'];
    avatar = json['avatar'];
    lastMessageText = json['lastMessageText'];
    lastSeenCount = json['lastSeenCount'];
  }
}

// class User {
//   String? sId;
//   String? contactUserId;
//   String? ownerUserId;
//   String? privacy;
//   String? categoryId;
//   String? createdAt;
//   String? name;
//   String? tab;
//   String? updatedAt;
//
//   User(
//       {this.sId,
//       this.contactUserId,
//       this.ownerUserId,
//       this.privacy,
//       this.categoryId,
//       this.createdAt,
//       this.name,
//       this.tab,
//       this.updatedAt});
//
//   User.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     contactUserId = json['contactUserId'];
//     ownerUserId = json['ownerUserId'];
//     privacy = json['privacy'];
//     categoryId = json['categoryId'];
//     createdAt = json['createdAt'];
//     name = json['name'];
//     tab = json['tab'];
//     updatedAt = json['updatedAt'];
//   }
// }
