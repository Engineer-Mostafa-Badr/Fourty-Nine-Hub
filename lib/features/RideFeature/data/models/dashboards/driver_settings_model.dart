import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/driver_settings_entity.dart';

class DriverSettingsModel extends DriverSettingsEntity {
  DriverSettingsModel({
    super.id,
    super.userId,
    super.isReady,
    super.profit,
    super.countTrips,
    super.isActive,
    super.isApproved,
    super.isRejected,
    super.rating,
    super.category,
  });

  factory DriverSettingsModel.fromJson(Map<String, dynamic> json) {
    return DriverSettingsModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      isReady: json['isReady'] as bool?,
      profit: json['profit'] as int?,
      countTrips: json['countTrips'] as int?,
      isActive: json['isActive'] as bool?,
      isApproved: json['isApproved'] as bool?,
      isRejected: json['isRejected'] as bool?,
      rating: json['rating'] != null
          ? RatingModel.fromJson(json['rating'])
          : null,
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
    );
  }
}

class RatingModel extends RatingEntity {
  RatingModel({super.average, super.count});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      average: (json['average'] as num?)?.toDouble(),
      count: json['count'] as int?,
    );
  }
}

class CategoryModel extends CategoryEntity {
  CategoryModel({
    super.subcategoryId,
    super.nameEn,
    super.nameAr,
    super.pictureUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      subcategoryId: json['subcategoryId'] != null
          ? SubCategoryModel.fromJson(json['subcategoryId'])
          : null,
      nameEn: json['nameEn'] as String?,
      nameAr: json['nameAr'] as String?,
      pictureUrl: json['pictureUrl'] as String?,
    );
  }
}

class SubCategoryModel extends SubCategoryEntity {
  SubCategoryModel({
    super.id,
    super.picture,
    super.nameAr,
    super.nameEn,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'] as String?,
      picture: json['picture'] as String?,
      nameAr: json['nameAr'] as String?,
      nameEn: json['nameEn'] as String?,
    );
  }
}
