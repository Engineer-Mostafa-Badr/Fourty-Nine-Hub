class ChatsRequestParams {
  String? privacyId;
  String? categoryId;
  bool? archived;
  bool? isLocked;
  bool? isUnread;
  bool? isServices;
  String? lockChatPassword;
  ChatsRequestParams({
     this.privacyId,
     this.categoryId,
     this.archived,
     this.isServices,
     this.isLocked,
     this.isUnread,
     this.lockChatPassword,
  });
}
