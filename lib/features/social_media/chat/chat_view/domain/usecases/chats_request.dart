class ChatsRequestParams {
  String? privacyId;
  String? categoryId;
  bool? archived;
  bool? isLocked;
  ChatsRequestParams({
     this.privacyId,
     this.categoryId,
     this.archived,
     this.isLocked,
  });
}
