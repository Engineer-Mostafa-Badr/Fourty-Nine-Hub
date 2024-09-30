import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/entities/media_entity.dart';

class CompanyAdEntity {
  final String? sId;
  final List<MediaEntity>? media; // Updated type
  final List<dynamic>? views;
  final String? advertisementType;
  final String? post;
  final num? totalPrice;
  final bool? isApproved;
  final String? type;
  final String? createdAt;
  final num? viewCount;

  CompanyAdEntity(
      {required this.sId,
      required this.media,
      required this.views,
      required this.advertisementType,
      required this.post,
      required this.totalPrice,
      required this.isApproved,
      required this.type,
      required this.createdAt,
      required this.viewCount});
}
