class MyAuctionImageEntity {
  final String id;
  final String user;
  final String subcategoryId;
  final String mimetype;
  final int size;
  final String mediaKey;
  final bool successUpload;
  final String createdAt;
  final String updatedAt;
  final String photo;

  MyAuctionImageEntity(
      {required this.id,
      required this.user,
      required this.subcategoryId,
      required this.mimetype,
      required this.size,
      required this.mediaKey,
      required this.successUpload,
      required this.createdAt,
      required this.updatedAt,
      required this.photo});
}
