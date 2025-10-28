class ActiveCategoryEntity {
  final String id;
  final String nameEn;
  final String nameAr;

  const ActiveCategoryEntity({
    required this.id,
    required this.nameEn,
    required this.nameAr,
  });

  String get displayName => nameEn; // or based on locale

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ActiveCategoryEntity &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              nameEn == other.nameEn &&
              nameAr == other.nameAr;

  @override
  int get hashCode => id.hashCode ^ nameEn.hashCode ^ nameAr.hashCode;

  @override
  String toString() =>
      'ActiveCategoryEntity(id: $id, nameEn: $nameEn, nameAr: $nameAr)';
}

class PaginationEntity {
  final int page;
  final int limit;
  final int total;
  final int pages;

  const PaginationEntity({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });
}

class ActiveCategoryDataEntity {
  final List<ActiveCategoryEntity> categories;
  final PaginationEntity pagination;

  const ActiveCategoryDataEntity({
    required this.categories,
    required this.pagination,
  });
}

class ActiveCategoryResponseEntity {
  final bool status;
  final ActiveCategoryDataEntity data;

  const ActiveCategoryResponseEntity({
    required this.status,
    required this.data,
  });
}
