import 'package:fourtyninehub/features/ads_feature/create_company_ad/data/models/company_ad_option_model.dart';
import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/entities/company_ad_entity.dart';

class CompanyAdModel extends CompanyAdEntity {
  CompanyAdModel(
      {required super.title,
      required super.allowVideo,
      required super.options});
  factory CompanyAdModel.fromJson(Map<String, dynamic> json) {
    return CompanyAdModel(
        title: json['title'],
        allowVideo: json['allow_video'],
        options: (json['options'] as List)
            .map((e) => CompanyAdOptionModel.fromJson(e))
            .toList());
  }
}
