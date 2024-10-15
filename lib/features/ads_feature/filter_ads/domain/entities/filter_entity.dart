import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/create_ad_entity.dart';

class FilterEntity{
  final List<CreateAdEntity> props;
  final CreateAdEntity? price;
  final String governorateId;
  final String cityId;
  final String? filter;
  final String subCategoryId;
  final int limit;
  final int page;

  FilterEntity({required this.price, required this.props,required this.cityId,required this.governorateId,required this.limit,required this.page,required this.subCategoryId,this.filter});

}