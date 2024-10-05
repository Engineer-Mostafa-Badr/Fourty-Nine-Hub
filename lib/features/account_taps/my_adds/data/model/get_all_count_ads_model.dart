import '../../domain/entity/get_all_count_ads_entity.dart';

class GetAllCountAdsModel extends GetAllCountAdsEntity {
  GetAllCountAdsModel(
      {required super.id,
      required super.firstName,
      required super.lastName,
      required super.gender,
      required super.email,
      required super.twitter_documentation});

  factory GetAllCountAdsModel.fromJson(Map<String, dynamic> json) {
      return GetAllCountAdsModel(
          id: json['_id'] ??'',
          firstName: json['firstName'] ??'',
          lastName: json['lastName'] ??'',
          gender: json['gender'] ??'',
          email: json['email'] ??'',
          twitter_documentation: json['twitter_documentation'] ??false,
      );
  }
}
