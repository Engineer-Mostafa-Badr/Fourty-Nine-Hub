class ChatsRequestParams {
  String? privacyId;
  String? categoryId;
  bool? archived;
  bool? isLocked;
  bool? isUnread;
  String? lockChatPassword;
  ChatsRequestParams({
    this.privacyId,
    this.categoryId,
    this.archived,
    this.isLocked,
    this.isUnread,
    this.lockChatPassword,
  });
}
