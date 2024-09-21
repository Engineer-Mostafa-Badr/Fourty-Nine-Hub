import 'package:fourtyninehub/features/account_taps/account/data/models/favouite_category_model/category_id.dart';

class FavouriteCategoryEntity {
  int? numberOfAds;
  DateTime? updatedAt;
  DateTime? createdAt;
  String? userId;
  String? id;
  CategoryId? categoryId;
  FavouriteCategoryEntity({
    required this.id,
    required this.numberOfAds,
    required this.updatedAt,
    required this.createdAt,
    required this.userId,
    required this.categoryId,
  });
}
