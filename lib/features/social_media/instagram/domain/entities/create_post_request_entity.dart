class CreatePostRequestEntity {
  final String itemId;
  final String mediaHolderId;
  final String signedUrl;

  CreatePostRequestEntity({
    required this.itemId,
    required this.mediaHolderId,
    required this.signedUrl,
  });
}