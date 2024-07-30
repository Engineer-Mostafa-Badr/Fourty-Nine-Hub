class ChatsRequestParams {
  String? privacyId;
  String? categoryId;
  bool? archived;
  bool? isLocked;
  String? lockChatPassword;
  ChatsRequestParams({
     this.privacyId,
     this.categoryId,
     this.archived,
     this.isLocked,
     this.lockChatPassword,
  });
}
