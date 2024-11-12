import 'package:fourtyninehub/core/utils/duration_helper.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/create_ad_entity.dart';
import 'package:intl/intl.dart';

class AdsSearchEntity {
  final String id;
  final String userId;
  final String subCategoryId;
  final String mainCategoryId;
  final String title;
  final String description;
  final bool adminIgnore;
  final List<ImageSearchEntity> images;
  final bool isActive;
  final bool isApproved;
  final bool isPremium;
  final String countryCode;
  final String subscriptionType;
  final num price;
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
   DateTime createdAt;
  final DateTime updatedAt;
  final List<String> phoneCount;
  final List<String> chatCount;
  final List<String> loveCount;
  final List<String> viewCount;
  final bool isBanned;
  final bool isBlocked;
  final bool isRejected;
   bool? isFavorite;
  final List<double> coordinates;
  List<CreateAdEntity> details;

  String get formatedDate => DateFormat('yyyy-MM-dd').format(createdAt);
  Duration get restTimeDuration => DateTime.now().difference(createdAt);

  String get formattedRestTime =>
      DurationHelper().sinceTime(duration: restTimeDuration);


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
      required this.subscriptionType,
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
       this.isFavorite=false,
      required this.coordinates,
      required this.details,
      });
}

class ImageSearchEntity{
  final String id;
  final String mediaKey;

  ImageSearchEntity({required this.id, required this.mediaKey});
}
