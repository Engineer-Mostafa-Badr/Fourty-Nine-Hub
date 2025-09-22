import 'chance_ad_entity.dart';

class ChanceAdsPaginationEntity {
  final List<ChanceAdEntity> data;
  final dynamic pagination;

  ChanceAdsPaginationEntity({
    required this.data,
    required this.pagination,
  });
}
