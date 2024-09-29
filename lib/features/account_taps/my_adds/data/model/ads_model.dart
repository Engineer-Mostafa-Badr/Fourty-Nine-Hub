import 'package:fourtyninehub/features/account_taps/my_adds/domain/entity/ads_entity.dart';

class AdDataAuctionModel extends AdDataAuctionEntity {
  AdDataAuctionModel(
      {required super.id,
      required super.userId,
      required super.subCategoryId,
      required super.mainCategoryId,
      required super.title,
      required super.desc,
      required super.address,
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
      required super.phone,
      required super.totalRating,
      required super.views,
      required super.requestsCount,
      required super.type,
      required super.createdAt,
      required super.updatedAt,
      required super.isDeleted});

  factory AdDataAuctionModel.fromJson(Map<String, dynamic> json) {
    return AdDataAuctionModel(
      id: json['_id'],
      userId: json['userId'],
      subCategoryId: json['subCategoryId'],
      mainCategoryId: json['mainCategoryId'],
      title: json['title'],
      desc: json['desc'],
      address: AddressModel.fromJson(json['address']),
      adminIgnore: json['adminIgnore'],
      images: List<String>.from(json['images']),
      isActive: json['isActive'],
      isApproved: json['isApproved'],
      isPremium: json['isPremium'],
      countryCode: json['countryCode'],
      price: json['price'],
      status: json['status'],
      searchText: json['searchText'],
      adminComments: List<String>.from(json['adminComments']),
      phone: json['phone'],
      totalRating: json['totalRating'],
      views: json['views'],
      requestsCount: json['requestsCount'],
      type: json['type'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt']  ,
      isDeleted: json['isDeleted'],
    );
  }
}

class AddressModel extends AddressEntity {
  AddressModel(
      {required super.coordinates,
      required super.city,
      required super.government});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      coordinates: json['coordinates'],
      city: json['city'],
      government: json['government'],
    );
  }
}
