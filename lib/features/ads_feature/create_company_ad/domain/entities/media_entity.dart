class MediaEntity {
  final String? sId;
  final String? user;
  final String? subcategoryId;
  final String? mediaKey;
  final bool? successUpload;
  final String? createdAt;
  final String? photo;

  MediaEntity(
      {required this.sId,
      required this.user,
      required this.subcategoryId,
      required this.mediaKey,
      required this.successUpload,
      required this.createdAt,
      required this.photo});
}
