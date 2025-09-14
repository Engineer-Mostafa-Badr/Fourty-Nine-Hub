import 'dart:convert';

class ActiveCategoryResponse {
  final bool status;
  final ActiveCategoryData data;

  ActiveCategoryResponse({
    required this.status,
    required this.data,
  });

  factory ActiveCategoryResponse.fromJson(Map<String, dynamic> json) {
    return ActiveCategoryResponse(
      status: json['status'] ?? false,
      data: ActiveCategoryData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class ActiveCategoryData {
  final List<ActiveCategory> categories;
  final Pagination pagination;

  ActiveCategoryData({
    required this.categories,
    required this.pagination,
  });

  factory ActiveCategoryData.fromJson(Map<String, dynamic> json) {
    return ActiveCategoryData(
      categories: (json['categories'] as List<dynamic>)
          .map((category) => ActiveCategory.fromJson(category))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories.map((category) => category.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class ActiveCategory {
  final String id;
  final String nameEn;
  final String nameAr;

  ActiveCategory({
    required this.id,
    required this.nameEn,
    required this.nameAr,
  });

  factory ActiveCategory.fromJson(Map<String, dynamic> json) {
    return ActiveCategory(
      id: json['_id'] ?? '',
      nameEn: json['nameEn'] ?? '',
      nameAr: json['nameAr'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nameEn': nameEn,
      'nameAr': nameAr,
    };
  }

  String get displayName {
    // You can implement language detection here
    // For now, return English name as default
    return nameEn;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ActiveCategory &&
           other.id == id &&
           other.nameEn == nameEn &&
           other.nameAr == nameAr;
  }

  @override
  int get hashCode => id.hashCode ^ nameEn.hashCode ^ nameAr.hashCode;

  @override
  String toString() {
    return 'ActiveCategory(id: $id, nameEn: $nameEn, nameAr: $nameAr)';
  }
}

class Pagination {
  final int page;
  final int limit;
  final int total;
  final int pages;

  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      pages: json['pages'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'pages': pages,
    };
  }
}