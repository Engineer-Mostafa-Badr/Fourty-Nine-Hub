class MainCategoryResponse {
  final bool status;
  final MainCategoryData data;

  MainCategoryResponse({
    required this.status,
    required this.data,
  });

  factory MainCategoryResponse.fromJson(Map<String, dynamic> json) {
    return MainCategoryResponse(
      status: json['status'],
      data: MainCategoryData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class MainCategoryData {
  final MainCategory mainCategory;

  MainCategoryData({
    required this.mainCategory,
  });

  factory MainCategoryData.fromJson(Map<String, dynamic> json) {
    return MainCategoryData(
      mainCategory: MainCategory.fromJson(json['mainCategory']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mainCategory': mainCategory.toJson(),
    };
  }
}

class MainCategory {
  final String id;
  final String banner;
  final String cover;
  final String nameAr;
  final String nameEn;
  final bool isFavorite;
  final int numberOfAds;

  MainCategory({
    required this.id,
    required this.banner,
    required this.cover,
    required this.nameAr,
    required this.nameEn,
    required this.isFavorite,
    required this.numberOfAds,
  });

  factory MainCategory.fromJson(Map<String, dynamic> json) {
    return MainCategory(
      id: json['_id'],
      banner: json['banner'],
      cover: json['cover'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      isFavorite: json['isFavorite'],
      numberOfAds: json['numberOfAds'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'banner': banner,
      'cover': cover,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'isFavorite': isFavorite,
      'numberOfAds': numberOfAds,
    };
  }
}
