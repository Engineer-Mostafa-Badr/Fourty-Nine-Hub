import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/entities/company_ad_option_entity.dart';

class CompanyAdOptionModel extends CompanyAdOptionEntity {
  CompanyAdOptionModel(
      {required super.userId,
      required super.advertisementType,
      required super.post,
      required super.totalPrice,
      required super.isApproved,
      required super.endAt,
      required super.type,
      required super.id,
      required super.createdAt});

  factory CompanyAdOptionModel.fromJson(Map<String, dynamic> json) {
    return CompanyAdOptionModel(
      userId: json['userId'] ?? '',
      advertisementType: json['advertisement_type'] ?? '',
      post: json['post'] ?? '',
      totalPrice: json['totalPrice'] ?? 0,
      isApproved: json['isApproved'] ?? false,
      endAt: json['endAt'] ?? '',
      type: json['type'] ?? '',
      id: json['_id'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}
