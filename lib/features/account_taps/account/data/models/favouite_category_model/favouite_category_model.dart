// import 'category_id.dart';

// class FavouriteCategoryModel {
// String? id;
// CategoryId? categoryId;
// String? userId;
// DateTime? createdAt;
// DateTime? updatedAt;
// int? numberOfAds;

//   FavouriteCategoryModel({
//     this.id,
//     this.categoryId,
//     this.userId,
//     this.createdAt,
//     this.updatedAt,
//     this.numberOfAds,
//   });

//   factory FavouriteCategoryModel.fromJson(Map<String, dynamic> json) {
// return FavouriteCategoryModel(
//   id: json['_id'] as String?,
//   categoryId: json['category_id'] == null
//       ? null
//       : CategoryId.fromJson(json['category_id'] as Map<String, dynamic>),
//   userId: json['user_id'] as String?,
//   createdAt: json['createdAt'] == null
//       ? nullz
//       : DateTime.parse(json['createdAt'] as String),
//   updatedAt: json['updatedAt'] == null
//       ? null
//       : DateTime.parse(json['updatedAt'] as String),
//   numberOfAds: json['numberOfAds'] as int?,
// );
//   }

//   Map<String, dynamic> toJson() => {
//         '_id': id,
//         'category_id': categoryId?.toJson(),
//         'user_id': userId,
//         'createdAt': createdAt?.toIso8601String(),
//         'updatedAt': updatedAt?.toIso8601String(),
//         'numberOfAds': numberOfAds,
//       };
// }
