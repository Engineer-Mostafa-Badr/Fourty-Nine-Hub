import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/entities/price_entity.dart';

class PriceModel extends PriceEntity {
  PriceModel(
      {required super.id,
      required super.photoPrice,
      required super.postPrice,
      required super.postAndPhotoPrice,
      required super.reelPrice,
      required super.isSubscribed,
      });

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      id: json['_id'],
      photoPrice: json['advertisementPhotoPrice'],
      postPrice: json['advertisementPostPrice'],
      postAndPhotoPrice: json['advertisementPostAndPhotoPrice'],
      reelPrice: json['advertisementReelPrice'],
      isSubscribed: json['isUserSubscribed'],
    );
  }
}
