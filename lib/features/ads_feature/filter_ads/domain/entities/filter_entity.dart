import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/create_ad_entity.dart';

class FilterEntity {
  final List<CreateAdEntity>? props;
  final CreateAdEntity? price;
  final String? governorateId;
  final String? cityId;
  final String? filter;
  final String? subCategoryId;
  final int? limit;
  final int? page;

  FilterEntity(
      {this.price,
      this.props,
      this.cityId,
      this.governorateId,
      this.limit,
      this.page,
      this.subCategoryId,
      this.filter});
}
