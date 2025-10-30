import 'package:fourtyninehub/features/tube/domain/entities/get_active_category_entity.dart';


class ActiveCategoryModel extends ActiveCategoryEntity {
  const ActiveCategoryModel({
    required super.id,
    required super.nameEn,
    required super.nameAr,
  });

  factory ActiveCategoryModel.fromJson(Map<String, dynamic> json) {
    return ActiveCategoryModel(
      id: json['_id'] ?? '',
      nameEn: json['nameEn'] ?? '',
      nameAr: json['nameAr'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'nameEn': nameEn,
    'nameAr': nameAr,
  };
}

class PaginationModel extends PaginationEntity {
  const PaginationModel({
    required super.page,
    required super.limit,
    required super.total,
    required super.pages,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      pages: json['pages'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
    'total': total,
    'pages': pages,
  };
}

class ActiveCategoryDataModel extends ActiveCategoryDataEntity {
  const ActiveCategoryDataModel({
    required super.categories,
    required super.pagination,
  });

  factory ActiveCategoryDataModel.fromJson(Map<String, dynamic> json) {
    return ActiveCategoryDataModel(
      categories: (json['categories'] as List<dynamic>)
          .map((e) => ActiveCategoryModel.fromJson(e))
          .toList(),
      pagination: PaginationModel.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() => {
    'categories': categories
        .map((category) => (category as ActiveCategoryModel).toJson())
        .toList(),
    'pagination': (pagination as PaginationModel).toJson(),
  };
}

class ActiveCategoryResponseModel extends ActiveCategoryResponseEntity {
  const ActiveCategoryResponseModel({
    required super.status,
    required super.data,
  });

  factory ActiveCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return ActiveCategoryResponseModel(
      status: json['status'] ?? false,
      data: ActiveCategoryDataModel.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': (data as ActiveCategoryDataModel).toJson(),
  };
}
