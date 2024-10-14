class MainSubCategorySearchEntity {
  final String id;
  final String banner;
  final String cover;
  final int index;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String nameAr;
  final String nameEn;
  final String nameCode;
  final bool isHidden;
  final bool enableInstallmentAndAuction;
   bool? isFavorite;

  MainSubCategorySearchEntity(
      {required this.id,
      required this.banner,
      required this.cover,
      required this.index,
      required this.createdAt,
      required this.updatedAt,
      required this.nameAr,
      required this.nameEn,
      required this.nameCode,
      required this.isHidden,
      required this.isFavorite,
      required this.enableInstallmentAndAuction});
}
