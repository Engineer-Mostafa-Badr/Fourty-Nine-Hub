class AdsSearchEntity {
  final String id;
  final String userId;
  final String subCategoryId;
  final String mainCategoryId;
  final String title;
  final String description;
  final bool adminIgnore;
  final List<String> images;
  final bool isActive;
  final bool isApproved;
  final bool isPremium;
  final String countryCode;
  final double price;
  final String status;
  final String searchText;
  final List<String> adminComments;
  final String phone;
  final int totalRating;
  final int views;
  final int requestsCount;
  final String type;
  final bool isDeleted;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> phoneCount;
  final List<String> chatCount;
  final List<String> loveCount;
  final List<String> viewCount;
  final bool isBanned;
  final bool isBlocked;
  final bool isRejected;
  final List<double> coordinates;

  AdsSearchEntity(
      {required this.id,
      required this.userId,
      required this.subCategoryId,
      required this.mainCategoryId,
      required this.title,
      required this.description,
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
      required this.isDeleted,
      required this.deletedAt,
      required this.createdAt,
      required this.updatedAt,
      required this.phoneCount,
      required this.chatCount,
      required this.loveCount,
      required this.viewCount,
      required this.isBanned,
      required this.isBlocked,
      required this.isRejected,
      required this.coordinates});
}
