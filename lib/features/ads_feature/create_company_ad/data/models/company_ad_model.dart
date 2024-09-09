import 'package:fourtyninehub/features/ads_feature/create_company_ad/data/models/media_model.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/entities/company_ad_entity.dart';

class CompanyAdModel extends CompanyAdEntity {
  CompanyAdModel(
      {required super.sId,
      required super.media,
      required super.views,
      required super.advertisementType,
      required super.post,
      required super.totalPrice,
      required super.isApproved,
      required super.type,
      required super.createdAt,
      required super.viewCount});

  factory CompanyAdModel.fromJson(Map<String, dynamic> json) {
    return CompanyAdModel(
        sId: json['_id'] ??'',
        media: json['media'] != null
            ? (json['media'] as List)
            .map((e) => MediaModel.fromJson(e as Map<String, dynamic>))
            .toList()
            : [],
        views: json['views'],
        advertisementType: json['advertisement_type'] ??'',
        post: json['post'] ??'',
        totalPrice: json['totalPrice'] ??0,
        isApproved: json['isApproved'] ??'',
        type: json['type']??'',
        createdAt: json['createdAt']??'',
        viewCount: json['viewCount'] ??0);
  }
}
