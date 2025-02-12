class CustomCategoriesModel {
  List<FavouriteCatFeature> categories;
  String id;
  String userId;

  CustomCategoriesModel({
    required this.categories,
    required this.id,
    required this.userId,
  });

  factory CustomCategoriesModel.fromJson(Map<String, dynamic> json) {
    List<FavouriteCatFeature> categoryList = [];

    json.forEach((key, value) {
      if (value is Map<String, dynamic> && value.containsKey('nameEn') && value.containsKey('nameAr')) {
        categoryList.add(FavouriteCatFeature.fromJson(value));
      }
    });

    return CustomCategoriesModel(
      categories: categoryList,
      id: json["_id"] ?? '',
      userId: json["userId"] ?? '',
    );
  }
}

class FavouriteCatFeature {
  final String nameEn;
  final String nameAr;
  bool? enabled;

  FavouriteCatFeature({
    required this.nameEn,
    required this.nameAr,
    required this.enabled,
  });

  factory FavouriteCatFeature.fromJson(Map<String, dynamic> json) {
    return FavouriteCatFeature(
      nameEn: json['nameEn'] ?? '',
      nameAr: json['nameAr'] ?? '',
      enabled: json['enabled'] ?? false,
    );
  }
}
