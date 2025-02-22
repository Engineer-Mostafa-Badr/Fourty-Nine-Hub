
import 'package:fourtyninehub/features/RideFeature/domain/entities/sub_category_entity.dart';

class SubCategoryModelUpdated extends SubCategoryEntityUpdated {
  SubCategoryModelUpdated({
    required super.subCategoryId,
    required super.subCategoryNameAr,
    required super.subCategoryNameEn,
    required super.picture,
    required super.driverCount,
    required super.isFavorite,
    required super.subscribedPremium,
  });

  factory SubCategoryModelUpdated.fromJson(Map<String, dynamic> json) {
    return SubCategoryModelUpdated(
      subCategoryId: json['subCategoryId'] ?? '',
      subCategoryNameAr: json['subCategoryNameAr'] ?? '',
      subCategoryNameEn: json['subCategoryNameEn'] ?? '',
      picture: json['picture'] ?? '',
      driverCount: json['driverCount'] ?? 0,
      isFavorite: json['isFavorite'] ?? false,
      subscribedPremium: json['subscribedPremium'] ?? false,
    );
  }
}
