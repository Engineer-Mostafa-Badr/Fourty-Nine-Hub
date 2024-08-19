// // // class GetFavCategoryModel {
// // //   bool? success;
// // //   Data? data;
// // //
// // //   GetFavCategoryModel({this.success, this.data});
// // //
// // //   GetFavCategoryModel.fromJson(Map<String, dynamic> json) {
// // //     success = json['success'];
// // //     data = json['data'] != null ? Data.fromJson(json['data']) : null;
// // //   }
// // //
// // //   Map<String, dynamic> toJson() {
// // //     final Map<String, dynamic> data = <String, dynamic>{};
// // //     data['success'] = this.success;
// // //     if (this.data != null) {
// // //       data['data'] = this.data!.toJson();
// // //     }
// // //     return data;
// // //   }
// // // }
// // //
// // // class Data {
// // //   List<FavoriteCategory>? favorites;
// // //
// // //   Data({this.favorites});
// // //
// // //   Data.fromJson(Map<String, dynamic> json) {
// // //     if (json['favorites'] != null) {
// // //       favorites = <FavoriteCategory>[];
// // //       json['favorites'].forEach((v) {
// // //         favorites!.add(FavoriteCategory.fromJson(v));
// // //       });
// // //     }
// // //   }
// // //
// // //   Map<String, dynamic> toJson() {
// // //     final Map<String, dynamic> data = <String, dynamic>{};
// // //     if (favorites != null) {
// // //       data['favorites'] = favorites!.map((v) => v.toJson()).toList();
// // //     }
// // //     return data;
// // //   }
// // // }
// // //
// // // class FavoriteCategory {
// // //   String? id;
// // //   String? categoryId;
// // //   User? user;
// // //   String? createdAt;
// // //   String? updatedAt;
// // //
// // //   FavoriteCategory({
// // //     this.id,
// // //     this.categoryId,
// // //     this.user,
// // //     this.createdAt,
// // //     this.updatedAt,
// // //   });
// // //
// // //   FavoriteCategory.fromJson(Map<String, dynamic> json) {
// // //     id = json['_id'];
// // //     categoryId = json['category_id'];
// // //     user = json['user_id'] != null ? User.fromJson(json['user_id']) : null;
// // //     createdAt = json['createdAt'];
// // //     updatedAt = json['updatedAt'];
// // //   }
// // //
// // //   Map<String, dynamic> toJson() {
// // //     final Map<String, dynamic> data = <String, dynamic>{};
// // //     data['_id'] = id;
// // //     data['category_id'] = categoryId;
// // //     if (user != null) {
// // //       data['user_id'] = user!.toJson();
// // //     }
// // //     data['createdAt'] = createdAt;
// // //     data['updatedAt'] = updatedAt;
// // //     return data;
// // //   }
// // // }
// // //
// // // class User {
// // //   Location? location;
// // //   String? id;
// // //   String? socketId;
// // //   String? firstName;
// // //   String? lastName;
// // //   String? email;
// // //   String? birthday;
// // //   String? hashedPassword;
// // //   String? gender;
// // //   bool? adminIgnore;
// // //   List<dynamic>? following;
// // //   List<dynamic>? blockedUsers;
// // //   List<dynamic>? hiddenPosts;
// // //   List<dynamic>? followers;
// // //   String? referralId;
// // //   bool? isLocked;
// // //   String? lockedDate;
// // //   bool? isRider;
// // //   bool? isDoctor;
// // //   bool? isRestaurant;
// // //   bool? isLoading;
// // //   String? language;
// // //   bool? isEmailVerified;
// // //   bool? isPhoneVerified;
// // //   bool? isDeleted;
// // //   String? countryCode;
// // //   List<dynamic>? auctionUsers;
// // //   List<dynamic>? installmentsUsers;
// // //   bool? twitterDocumentation;
// // //   String? username;
// // //   String? createdAt;
// // //   String? updatedAt;
// // //   String? chatPassword;
// // //
// // //   User({
// // //     this.location,
// // //     this.id,
// // //     this.socketId,
// // //     this.firstName,
// // //     this.lastName,
// // //     this.email,
// // //     this.birthday,
// // //     this.hashedPassword,
// // //     this.gender,
// // //     this.adminIgnore,
// // //     this.following,
// // //     this.blockedUsers,
// // //     this.hiddenPosts,
// // //     this.followers,
// // //     this.referralId,
// // //     this.isLocked,
// // //     this.lockedDate,
// // //     this.isRider,
// // //     this.isDoctor,
// // //     this.isRestaurant,
// // //     this.isLoading,
// // //     this.language,
// // //     this.isEmailVerified,
// // //     this.isPhoneVerified,
// // //     this.isDeleted,
// // //     this.countryCode,
// // //     this.auctionUsers,
// // //     this.installmentsUsers,
// // //     this.twitterDocumentation,
// // //     this.username,
// // //     this.createdAt,
// // //     this.updatedAt,
// // //     this.chatPassword,
// // //   });
// // //
// // //   User.fromJson(Map<String, dynamic> json) {
// // //     location = json['location'] != null ? Location.fromJson(json['location']) : null;
// // //     id = json['_id'];
// // //     socketId = json['socketId'];
// // //     firstName = json['firstName'];
// // //     lastName = json['lastName'];
// // //     email = json['email'];
// // //     birthday = json['birthday'];
// // //     hashedPassword = json['hashedPassword'];
// // //     gender = json['gender'];
// // //     adminIgnore = json['adminIgnore'];
// // //     following = json['following'];
// // //     blockedUsers = json['blockedUsers'];
// // //     hiddenPosts = json['hiddenPosts'];
// // //     followers = json['followers'];
// // //     referralId = json['referralId'];
// // //     isLocked = json['isLocked'];
// // //     lockedDate = json['lockedDate'];
// // //     isRider = json['isRider'];
// // //     isDoctor = json['isDoctor'];
// // //     isRestaurant = json['isRestaurant'];
// // //     isLoading = json['isLoading'];
// // //     language = json['language'];
// // //     isEmailVerified = json['isEmailVerified'];
// // //     isPhoneVerified = json['isPhoneVerified'];
// // //     isDeleted = json['isDeleted'];
// // //     countryCode = json['countryCode'];
// // //     auctionUsers = json['auction_users'];
// // //     installmentsUsers = json['installments_users'];
// // //     twitterDocumentation = json['twitter_documentation'];
// // //     username = json['username'];
// // //     createdAt = json['createdAt'];
// // //     updatedAt = json['updatedAt'];
// // //     chatPassword = json['chatPassword'];
// // //   }
// // //
// // //   Map<String, dynamic> toJson() {
// // //     final Map<String, dynamic> data = <String, dynamic>{};
// // //     if (location != null) {
// // //       data['location'] = location!.toJson();
// // //     }
// // //     data['_id'] = id;
// // //     data['socketId'] = socketId;
// // //     data['firstName'] = firstName;
// // //     data['lastName'] = lastName;
// // //     data['email'] = email;
// // //     data['birthday'] = birthday;
// // //     data['hashedPassword'] = hashedPassword;
// // //     data['gender'] = gender;
// // //     data['adminIgnore'] = adminIgnore;
// // //     data['following'] = following;
// // //     data['blockedUsers'] = blockedUsers;
// // //     data['hiddenPosts'] = hiddenPosts;
// // //     data['followers'] = followers;
// // //     data['referralId'] = referralId;
// // //     data['isLocked'] = isLocked;
// // //     data['lockedDate'] = lockedDate;
// // //     data['isRider'] = isRider;
// // //     data['isDoctor'] = isDoctor;
// // //     data['isRestaurant'] = isRestaurant;
// // //     data['isLoading'] = isLoading;
// // //     data['language'] = language;
// // //     data['isEmailVerified'] = isEmailVerified;
// // //     data['isPhoneVerified'] = isPhoneVerified;
// // //     data['isDeleted'] = isDeleted;
// // //     data['countryCode'] = countryCode;
// // //     data['auction_users'] = auctionUsers;
// // //     data['installments_users'] = installmentsUsers;
// // //     data['twitter_documentation'] = twitterDocumentation;
// // //     data['username'] = username;
// // //     data['createdAt'] = createdAt;
// // //     data['updatedAt'] = updatedAt;
// // //     data['chatPassword'] = chatPassword;
// // //     return data;
// // //   }
// // // }
// // //
// // // class Location {
// // //   String? type;
// // //   List<double>? coordinates;
// // //
// // //   Location({this.type, this.coordinates});
// // //
// // //   Location.fromJson(Map<String, dynamic> json) {
// // //     type = json['type'];
// // //     if (json['coordinates'] != null) {
// // //       coordinates = List<double>.from(json['coordinates'].map((x) => x.toDouble()));
// // //     }
// // //   }
// // //
// // //   Map<String, dynamic> toJson() {
// // //     final Map<String, dynamic> data = <String, dynamic>{};
// // //     data['type'] = type;
// // //     if (coordinates != null) {
// // //       data['coordinates'] = coordinates;
// // //     }
// // //     return data;
// // //   }
// // // }
// // import 'dart:convert';
// //
// // class GetFavCategoryModel {
// //   bool? success;
// //   FavoritesData? data;
// //
// //   GetFavCategoryModel({this.success, this.data});
// //
// //   factory GetFavCategoryModel.fromJson(Map<String, dynamic> json) {
// //     return GetFavCategoryModel(
// //       success: json['success'],
// //       data: json['data'] != null ? FavoritesData.fromJson(json['data']) : null,
// //     );
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     return {
// //       'success': success,
// //       'data': data?.toJson(),
// //     };
// //   }
// // }
// //
// // class FavoritesData {
// //   List<Favorite>? favorites;
// //
// //   FavoritesData({this.favorites});
// //
// //   factory FavoritesData.fromJson(Map<String, dynamic> json) {
// //     return FavoritesData(
// //       favorites: json['favorites'] != null
// //           ? (json['favorites'] as List).map((i) => Favorite.fromJson(i)).toList()
// //           : null,
// //     );
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     return {
// //       'favorites': favorites?.map((i) => i.toJson()).toList(),
// //     };
// //   }
// // }
// //
// // class Favorite {
// //   String? id;
// //   Category? category;
// //   User? user;
// //   String? createdAt;
// //   String? updatedAt;
// //
// //   Favorite({this.id, this.category, this.user, this.createdAt, this.updatedAt});
// //
// //   factory Favorite.fromJson(Map<String, dynamic> json) {
// //     return Favorite(
// //       id: json['_id'],
// //       category: json['category_id'] != null ? Category.fromJson(json['category_id']) : null,
// //       user: json['user_id'] != null ? User.fromJson(json['user_id']) : null,
// //       createdAt: json['createdAt'],
// //       updatedAt: json['updatedAt'],
// //     );
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     return {
// //       '_id': id,
// //       'category_id': category?.toJson(),
// //       'user_id': user?.toJson(),
// //       'createdAt': createdAt,
// //       'updatedAt': updatedAt,
// //     };
// //   }
// // }
// //
// // class Category {
// //   String? id;
// //   String? banner;
// //   String? cover;
// //   int? index;
// //   String? createdAt;
// //   String? updatedAt;
// //   String? nameAr;
// //   String? nameEn;
// //   String? nameCode;
// //   bool? isHidden;
// //   bool? enableInstallmentAndAuction;
// //
// //   Category({
// //     this.id,
// //     this.banner,
// //     this.cover,
// //     this.index,
// //     this.createdAt,
// //     this.updatedAt,
// //     this.nameAr,
// //     this.nameEn,
// //     this.nameCode,
// //     this.isHidden,
// //     this.enableInstallmentAndAuction,
// //   });
// //
// //   factory Category.fromJson(Map<String, dynamic> json) {
// //     return Category(
// //       id: json['_id'],
// //       banner: json['banner'],
// //       cover: json['cover'],
// //       index: json['index'],
// //       createdAt: json['createdAt'],
// //       updatedAt: json['updatedAt'],
// //       nameAr: json['nameAr'],
// //       nameEn: json['nameEn'],
// //       nameCode: json['nameCode'],
// //       isHidden: json['isHidden'],
// //       enableInstallmentAndAuction: json['EnableInstallmentAndAuction'],
// //     );
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     return {
// //       '_id': id,
// //       'banner': banner,
// //       'cover': cover,
// //       'index': index,
// //       'createdAt': createdAt,
// //       'updatedAt': updatedAt,
// //       'nameAr': nameAr,
// //       'nameEn': nameEn,
// //       'nameCode': nameCode,
// //       'isHidden': isHidden,
// //       'EnableInstallmentAndAuction': enableInstallmentAndAuction,
// //     };
// //   }
// // }
// //
// // class User {
// //   Location? location;
// //   String? id;
// //   String? socketId;
// //   String? firstName;
// //   String? lastName;
// //   String? email;
// //   String? birthday;
// //   String? hashedPassword;
// //   String? gender;
// //   bool? adminIgnore;
// //   List<dynamic>? following;
// //   List<dynamic>? blockedUsers;
// //   List<dynamic>? hiddenPosts;
// //   List<dynamic>? followers;
// //   String? referralId;
// //   bool? isLocked;
// //   String? lockedDate;
// //   bool? isRider;
// //   bool? isDoctor;
// //   bool? isRestaurant;
// //   bool? isLoading;
// //   String? language;
// //   bool? isEmailVerified;
// //   bool? isPhoneVerified;
// //   bool? isDeleted;
// //   String? countryCode;
// //   List<String>? auctionUsers;
// //   List<String>? installmentsUsers;
// //   bool? twitterDocumentation;
// //   String? username;
// //   String? createdAt;
// //   String? updatedAt;
// //   String? chatPassword;
// //
// //   User({
// //     this.location,
// //     this.id,
// //     this.socketId,
// //     this.firstName,
// //     this.lastName,
// //     this.email,
// //     this.birthday,
// //     this.hashedPassword,
// //     this.gender,
// //     this.adminIgnore,
// //     this.following,
// //     this.blockedUsers,
// //     this.hiddenPosts,
// //     this.followers,
// //     this.referralId,
// //     this.isLocked,
// //     this.lockedDate,
// //     this.isRider,
// //     this.isDoctor,
// //     this.isRestaurant,
// //     this.isLoading,
// //     this.language,
// //     this.isEmailVerified,
// //     this.isPhoneVerified,
// //     this.isDeleted,
// //     this.countryCode,
// //     this.auctionUsers,
// //     this.installmentsUsers,
// //     this.twitterDocumentation,
// //     this.username,
// //     this.createdAt,
// //     this.updatedAt,
// //     this.chatPassword,
// //   });
// //
// //   factory User.fromJson(Map<String, dynamic> json) {
// //     return User(
// //       location: json['location'] != null ? Location.fromJson(json['location']) : null,
// //       id: json['_id'],
// //       socketId: json['socketId'],
// //       firstName: json['firstName'],
// //       lastName: json['lastName'],
// //       email: json['email'],
// //       birthday: json['birthday'],
// //       hashedPassword: json['hashedPassword'],
// //       gender: json['gender'],
// //       adminIgnore: json['adminIgnore'],
// //       following: json['following'] != null ? List<dynamic>.from(json['following']) : null,
// //       blockedUsers: json['blockedUsers'] != null ? List<dynamic>.from(json['blockedUsers']) : null,
// //       hiddenPosts: json['hiddenPosts'] != null ? List<dynamic>.from(json['hiddenPosts']) : null,
// //       followers: json['followers'] != null ? List<dynamic>.from(json['followers']) : null,
// //       referralId: json['referralId'],
// //       isLocked: json['isLocked'],
// //       lockedDate: json['lockedDate'],
// //       isRider: json['isRider'],
// //       isDoctor: json['isDoctor'],
// //       isRestaurant: json['isRestaurant'],
// //       isLoading: json['isLoading'],
// //       language: json['language'],
// //       isEmailVerified: json['isEmailVerified'],
// //       isPhoneVerified: json['isPhoneVerified'],
// //       isDeleted: json['isDeleted'],
// //       countryCode: json['countryCode'],
// //       auctionUsers: json['auction_users'] != null ? List<String>.from(json['auction_users']) : null,
// //       installmentsUsers: json['installments_users'] != null ? List<String>.from(json['installments_users']) : null,
// //       twitterDocumentation: json['twitter_documentation'],
// //       username: json['username'],
// //       createdAt: json['createdAt'],
// //       updatedAt: json['updatedAt'],
// //       chatPassword: json['chatPassword'],
// //     );
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     return {
// //       'location': location?.toJson(),
// //       '_id': id,
// //       'socketId': socketId,
// //       'firstName': firstName,
// //       'lastName': lastName,
// //       'email': email,
// //       'birthday': birthday,
// //       'hashedPassword': hashedPassword,
// //       'gender': gender,
// //       'adminIgnore': adminIgnore,
// //       'following': following,
// //       'blockedUsers': blockedUsers,
// //       'hiddenPosts': hiddenPosts,
// //       'followers': followers,
// //       'referralId': referralId,
// //       'isLocked': isLocked,
// //       'lockedDate': lockedDate,
// //       'isRider': isRider,
// //       'isDoctor': isDoctor,
// //       'isRestaurant': isRestaurant,
// //       'isLoading': isLoading,
// //       'language': language,
// //       'isEmailVerified': isEmailVerified,
// //       'isPhoneVerified': isPhoneVerified,
// //       'isDeleted': isDeleted,
// //       'countryCode': countryCode,
// //       'auction_users': auctionUsers,
// //       'installments_users': installmentsUsers,
// //       'twitter_documentation': twitterDocumentation,
// //       'username': username,
// //       'createdAt': createdAt,
// //       'updatedAt': updatedAt,
// //       'chatPassword': chatPassword,
// //     };
// //   }
// // }
// //
// // class Location {
// //   String? type;
// //   List<double>? coordinates;
// //
// //   Location({this.type, this.coordinates});
// //
// //   factory Location.fromJson(Map<String, dynamic> json) {
// //     return Location(
// //       type: json['type'],
// //       coordinates: json['coordinates'] != null
// //           ? List<double>.from(json['coordinates'].map((x) => x.toDouble()))
// //           : null,
// //     );
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     return {
// //       'type': type,
// //       'coordinates': coordinates,
// //     };
// //   }
// // }
//
// class SubFavoritesResponse {
//   final bool status;
//   final List<FavoriteItem> favorites;
//
//   SubFavoritesResponse({required this.status, required this.favorites});
//
//   factory SubFavoritesResponse.fromJson(Map<String, dynamic> json) {
//     return SubFavoritesResponse(
//       status: json['status'],
//       favorites: List<FavoriteItem>.from(
//           json['data'].map((item) => FavoriteItem.fromJson(item))),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'status': status,
//       'data': favorites.map((item) => item.toJson()).toList(),
//     };
//   }
// }
//
// class FavoriteItem {
//   final String id;
//   final String userId;
//   final String subCategoryId;
//   final String createdAt;
//   final String updatedAt;
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
//       subCategoryId: json['subCategoryId'],
//       createdAt: json['createdAt'],
//       updatedAt: json['updatedAt'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'userId': userId,
//       'subCategoryId': subCategoryId,
//       'createdAt': createdAt,
//       'updatedAt': updatedAt,
//     };
//   }
// }

import 'dart:convert';

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
      data: List<FavoriteItem>.from(json['data'].map((x) => FavoriteItem.fromJson(x))),
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
