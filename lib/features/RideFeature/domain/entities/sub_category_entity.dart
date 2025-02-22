class SubCategoryEntityUpdated {
  final String subCategoryId;
  final String subCategoryNameAr;
  final String subCategoryNameEn;
  final String picture;
  final int driverCount;
  final bool isFavorite;
  final bool subscribedPremium;

  SubCategoryEntityUpdated({
    required this.subCategoryId,
    required this.subCategoryNameAr,
    required this.subCategoryNameEn,
    required this.picture,
    required this.driverCount,
    required this.isFavorite,
    required this.subscribedPremium,
  });
}
