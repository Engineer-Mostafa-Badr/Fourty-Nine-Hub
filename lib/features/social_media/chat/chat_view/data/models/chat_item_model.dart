class ChatItemModel {
  String? sId;
  String? lastMessageText;
  User? user;
  int? lastSeenCount;

  ChatItemModel(
      {this.sId, this.lastMessageText, this.user, this.lastSeenCount});

  ChatItemModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    lastMessageText = json['lastMessageText'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    lastSeenCount = json['lastSeenCount'];
  }
}

class User {
  String? sId;
  String? contactUserId;
  String? ownerUserId;
  String? privacy;
  String? categoryId;
  String? createdAt;
  String? name;
  String? tab;
  String? updatedAt;

  User(
      {this.sId,
      this.contactUserId,
      this.ownerUserId,
      this.privacy,
      this.categoryId,
      this.createdAt,
      this.name,
      this.tab,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    contactUserId = json['contactUserId'];
    ownerUserId = json['ownerUserId'];
    privacy = json['privacy'];
    categoryId = json['categoryId'];
    createdAt = json['createdAt'];
    name = json['name'];
    tab = json['tab'];
    updatedAt = json['updatedAt'];
  }
}
