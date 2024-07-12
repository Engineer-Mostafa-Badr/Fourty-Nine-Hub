import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/entities/company_ad_option_entity.dart';

class CompanyAdEntity {
  final String title;
  final bool allowVideo;
  final List<CompanyAdOptionEntity> options;
  CompanyAdEntity({
    required this.title, 
    required this.allowVideo, 
    required this.options
  });
}
