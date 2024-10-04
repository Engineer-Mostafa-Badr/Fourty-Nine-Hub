//
//
// class SubFavoritesResponse {
//   final bool status;
//   final List<FavoriteItem> data;
//
//   SubFavoritesResponse({
//     required this.status,
//     required this.data,
//   });
//
//   factory SubFavoritesResponse.fromJson(Map<String, dynamic> json) {
//     return SubFavoritesResponse(
//       status: json['status'],
//       data: List<FavoriteItem>.from(json['data'].map((x) => FavoriteItem.fromJson(x))),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'status': status,
//       'data': List<dynamic>.from(data.map((x) => x.toJson())),
//     };
//   }
// }
//
// class FavoriteItem {
//   final String id;
//   final String userId;
//   final SubCategory subCategoryId;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//
//   FavoriteItem({
//     required this.id,
//     required this.userId,
//     required this.subCategoryId,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory FavoriteItem.fromJson(Map<String, dynamic> json) {
//     return FavoriteItem(
//       id: json['_id'],
//       userId: json['userId'],
//       subCategoryId: SubCategory.fromJson(json['subCategoryId']),
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'userId': userId,
//       'subCategoryId': subCategoryId.toJson(),
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//     };
//   }
// }
//
// class SubCategory {
//   final String id;
//   final String picture;
//   final String nameAr;
//   final String nameEn;
//
//   SubCategory({
//     required this.id,
//     required this.picture,
//     required this.nameAr,
//     required this.nameEn,
//   });
//
//   factory SubCategory.fromJson(Map<String, dynamic> json) {
//     return SubCategory(
//       id: json['_id'],
//       picture: json['picture'],
//       nameAr: json['nameAr'],
//       nameEn: json['nameEn'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'picture': picture,
//       'nameAr': nameAr,
//       'nameEn': nameEn,
//     };
//   }
// }

class SubFavoritesResponse {
  final bool status;
  final List<FavoriteItem> data;

  SubFavoritesResponse({
    required this.status,
    required this.data,
  });

  factory SubFavoritesResponse.fromJson(Map<String, dynamic> json) {
    return SubFavoritesResponse(
      status: json['status'],
      data: List<FavoriteItem>.from(
        json['data'].map((x) => FavoriteItem.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}

class FavoriteItem {
  final String id;
  final String userId;
  final SubCategory subCategoryId;
  final DateTime createdAt;
  final DateTime updatedAt;

  FavoriteItem({
    required this.id,
    required this.userId,
    required this.subCategoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['_id'],
      userId: json['userId'],
      subCategoryId: SubCategory.fromJson(json['subCategoryId']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'subCategoryId': subCategoryId.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class SubCategory {
  final String id;
  final String picture;
  final String nameAr;
  final String nameEn;

  SubCategory({
    required this.id,
    required this.picture,
    required this.nameAr,
    required this.nameEn,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['_id'],
      picture: json['picture'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'picture': picture,
      'nameAr': nameAr,
      'nameEn': nameEn,
    };
  }
}
