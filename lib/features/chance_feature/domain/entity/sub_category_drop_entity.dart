class SubCategoryDropEntity {
  final String id;
  final String parent;
  final String picture;
  final bool hasAuction;
  final String nameAr;
  final String nameEn;
  final bool isFavorite;
  final int numberOfAdsCount;

  SubCategoryDropEntity({
    required this.id,
    required this.parent,
    required this.picture,
    required this.hasAuction,
    required this.nameAr,
    required this.nameEn,
    required this.isFavorite,
    required this.numberOfAdsCount,
  });
}
