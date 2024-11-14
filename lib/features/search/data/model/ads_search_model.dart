import 'package:fourtyninehub/features/ads_feature/create_ad/data/models/create_ad_model.dart';
import 'package:fourtyninehub/features/search/domain/entity/ads_search_entity.dart';

class AdsSearchModel extends AdsSearchEntity {
  AdsSearchModel({
    required super.id,
    required super.userId,
    required super.subCategoryId,
    required super.mainCategoryId,
    required super.title,
    required super.description,
    required super.adminIgnore,
    required super.images,
    required super.isActive,
    required super.isApproved,
    required super.isPremium,
    required super.countryCode,
    required super.price,
    required super.status,
    required super.searchText,
    required super.adminComments,
    required super.subscriptionType,
    required super.phone,
    required super.totalRating,
    required super.views,
    required super.requestsCount,
    required super.type,
    required super.isDeleted,
    required super.deletedAt,
    required super.createdAt,
    required super.updatedAt,
    required super.phoneCount,
    required super.chatCount,
    required super.loveCount,
    required super.viewCount,
    required super.isBanned,
    required super.isBlocked,
    required super.isRejected,
    super.isFavorite,
    required super.coordinates,
    required super.details,
  });

  factory AdsSearchModel.fromJson(Map<String, dynamic> json) {
    return AdsSearchModel(
        id: json['_id'] ?? '',
        userId: json['userId']['_id'] ?? '',
        subCategoryId: json['subCategoryId'] ?? '',
        mainCategoryId: json['mainCategoryId'] ?? '',
        title: json['title'] ?? '',
        description: json['desc'] ?? '',
        adminIgnore: json['adminIgnore'] ?? false,
        images: json['images'] == null
            ? []
            : (json['images'] as List)
            .map((e) => ImageSearchModel.fromJson(e))
            .toList(),
        isActive: json['isActive'] ?? false,
        isApproved: json['isApproved'] ?? false,
        isPremium: json['isPremium'] ?? false,
        countryCode: json['countryCode'] ?? '',
        price: json['price'].toDouble() ?? 0,
        status: json['status'] ?? '',
        searchText: json['searchText'] ?? '',
        subscriptionType: json['subscriptionType'] ?? '',
        adminComments: List<String>.from(json['adminComments']),
        phone: json['phone'] ?? '',
        totalRating: json['totalRating'] ?? 0,
        views: json['views'] ?? 0,
        requestsCount: json['requestsCount'] ?? 0,
        type: json['type'] ?? '',
        isDeleted: json['isDeleted'] ?? false,
        deletedAt: json['deletedAt'] != null
            ? DateTime.parse(json['deletedAt'])
            : null,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        phoneCount: List<String>.from(json['phoneCount']),
        chatCount: List<String>.from(json['chatCount']),
        loveCount: List<String>.from(json['loveCount']),
        viewCount: List<String>.from(json['viewCount']),
        isBanned: json['isBanned'] ?? false,
        isBlocked: json['isBlocked'] ?? false,
        isRejected: json['isRejected'] ?? false,
        isFavorite: json['isFavorite'] ?? false,
        coordinates: List<double>.from(json['address']['coordinates']),
        details: json['propsPivot'] == null
            ? []
            : (json['propsPivot'] as List)
                .map((e) => CreateAdModel.fromJson(e))
                .toList());
  }
}

class ImageSearchModel extends ImageSearchEntity {
  ImageSearchModel({required super.id, required super.mediaKey});

  factory ImageSearchModel.fromJson(Map<String, dynamic> json) {
    return ImageSearchModel(
        id: json['_id'] ?? '', mediaKey: json['mediaKey'] ?? '');
  }
}
