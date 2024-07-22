
import '../../../../ads_feature/ads/data/models/Ad_model.dart';
import '../../domain/entities/favourite_ad_entity.dart';

class FavouriteAdModel extends FavouriteAdEntity{
  FavouriteAdModel({required super.id, required super.item});

  factory FavouriteAdModel.fromJson(Map<String, dynamic> json) {
    return FavouriteAdModel(
      id: json['_id'],
      item: AdModel.fromJson(json['adId']),
      // id: json['id'],
    );
  }
}
