import 'package:fourtyninehub/features/search/domain/entity/ads_search_entity.dart';

import 'create_ad_search_model.dart';

class AdsSearchModel extends AdsSearchEntity {
  AdsSearchModel({
    required super.id,
    super.userId,
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
    required super.details,
    // required super.address,
  });

  factory AdsSearchModel.fromJson(Map<String, dynamic> json) {
    // bool count = true;
    // if(count){
    //   print('==> ads subCategoryId ${json['subCategoryId']} ${json['subCategoryId'].runtimeType}');
    //   print('==> ads mainCategoryId ${json['mainCategoryId']} ${json['mainCategoryId'].runtimeType}');
    //   print('==> ads title ${json['title']} ${json['title'].runtimeType}');
    //   print('==> ads desc ${json['desc']} ${json['desc'].runtimeType}');
    //   print('==> ads images ${json['images']} ${json['images'].runtimeType}');
    //   print('==> ads isActive ${json['isActive']} ${json['isActive'].runtimeType}');
    //   print('==> ads countryCode ${json['countryCode']} ${json['countryCode'].runtimeType}');
    //   print('==> ads subscriptionType ${json['subscriptionType']} ${json['subscriptionType'].runtimeType}');
    //   print('==> ads status ${json['status']} ${json['status'].runtimeType}');
    //   print('==> ads searchText ${json['searchText']} ${json['searchText'].runtimeType}');
    //   print('==> ads phone ${json['phone']} ${json['phone'].runtimeType}');
    //   print('==> ads type ${json['type']} ${json['type'].runtimeType}');
    //   print('==> ads type ${json['type']} ${json['type'].runtimeType}');
    //   count = false;
    // }
    return AdsSearchModel(
        id: json['_id'] ?? '',
        userId: json['userId']?['_id'] ?? '',
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
        price: json['price'] ?? 0,
        status: json['status'] ?? '',
        searchText: json['searchText'] ?? '',
        subscriptionType: json['subscriptionType'] ?? '',
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
        phoneCount: json['phoneCount'] != null
            ? List<String>.from(json['phoneCount'])
            : [],
        chatCount: json['chatCount'] != null
            ? List<String>.from(json['chatCount'])
            : [],
        loveCount: json['loveCount'] != null
            ? List<String>.from(json['loveCount'])
            : [],
        viewCount: json['viewCount'] != null
            ? List<String>.from(json['viewCount'])
            : [],
        isBanned: json['isBanned'] ?? false,
        isBlocked: json['isBlocked'] ?? false,
        isRejected: json['isRejected'] ?? false,
        isFavorite: json['isFavorite'] ?? false,
        // address: json['isFavorite'] ?? false,
        details: json['propsPivot'] == null
            ? []
            : (json['propsPivot'] as List)
                .map((e) => CreateAdSearchModel.fromJson(e))
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
