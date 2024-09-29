class AdDataAuctionEntity {
  final String id;
  final String userId;
  final String subCategoryId;
  final String mainCategoryId;
  final String title;
  final String desc;
  final AddressEntity address;
  final bool adminIgnore;
  final List<String> images;
  final bool isActive;
  final bool isApproved;
  final bool isPremium;
  final String countryCode;
  final int price;
  final String status;
  final String searchText;
  final List<String> adminComments;
  final String phone;
  final int totalRating;
  final int views;
  final int requestsCount;
  final String type;
  final String createdAt;
  final String updatedAt;
  final bool isDeleted;

  AdDataAuctionEntity(
      {required this.id,
      required this.userId,
      required this.subCategoryId,
      required this.mainCategoryId,
      required this.title,
      required this.desc,
      required this.address,
      required this.adminIgnore,
      required this.images,
      required this.isActive,
      required this.isApproved,
      required this.isPremium,
      required this.countryCode,
      required this.price,
      required this.status,
      required this.searchText,
      required this.adminComments,
      required this.phone,
      required this.totalRating,
      required this.views,
      required this.requestsCount,
      required this.type,
      required this.createdAt,
      required this.updatedAt,
      required this.isDeleted});
}

class AddressEntity {
  final String coordinates;
  final String city;
  final String government;

  AddressEntity({
    required this.coordinates,
    required this.city,
    required this.government,
  });
}
