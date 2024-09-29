import '../../domain/entity/my_auction_image_entity.dart';

class MyAuctionImageModel extends MyAuctionImageEntity {
  MyAuctionImageModel(
      {required super.id,
      required super.user,
      required super.subcategoryId,
      required super.mimetype,
      required super.size,
      required super.mediaKey,
      required super.successUpload,
      required super.createdAt,
      required super.updatedAt,
      required super.photo});

  factory MyAuctionImageModel.fromJson(Map<String, dynamic> json) {
      return MyAuctionImageModel(
          id: json['_id'],
          user: json['user'],
          subcategoryId: json['subcategoryId'],
          mimetype: json['mimetype'],
          size: json['size'],
          mediaKey: json['mediaKey'],
          successUpload: json['successUpload'],
          createdAt: json['createdAt'],
          updatedAt: json['updatedAt'],
          photo: json['photo'] ??'',
      );
  }
}
