import '../../domain/entity/chance_ads_pagination_entity.dart';
import 'chance_ad_model.dart';

class ChanceAdsPaginationModel extends ChanceAdsPaginationEntity {
  ChanceAdsPaginationModel({
    required super.data,
    required super.pagination,
  });

  factory ChanceAdsPaginationModel.fromJson(Map<String, dynamic> json) {
    return ChanceAdsPaginationModel(
      data: (json['data'] as List? ?? [])
          .map((ad) => ChanceAdModel.fromJson(ad))
          .toList(),
      pagination: PaginationInfoModel.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((ad) => (ad as ChanceAdModel).toJson()).toList(),
      'pagination': (pagination as PaginationInfoModel).toJson(),
    };
  }
}

class PaginationInfoModel {
  final int total;
  final int page;
  final int limit;
  final int pages;
  final int? countItem;
  final int? pageCount;

  PaginationInfoModel({
    required this.total,
    required this.page,
    required this.limit,
    required this.pages,
    this.countItem,
    this.pageCount,
  });

  factory PaginationInfoModel.fromJson(Map<String, dynamic> json) {
    return PaginationInfoModel(
      total: json['total'] ?? json['countItem'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      pages: json['pages'] ?? json['pageCount'] ?? 1,
      countItem: json['countItem'],
      pageCount: json['pageCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'limit': limit,
      'pages': pages,
      if (countItem != null) 'countItem': countItem,
      if (pageCount != null) 'pageCount': pageCount,
    };
  }
}
