import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/entities/company_ad_option_entity.dart';

class CompanyAdOptionModel extends CompanyAdOptionEntity {
  CompanyAdOptionModel(
      {required super.title, required super.subTitle, required super.price});

  factory CompanyAdOptionModel.fromJson(Map<String, dynamic> json) {
    return CompanyAdOptionModel(
        title: json['title'], subTitle: json['subtitle'], price: json['price']);
  }
}
