class SubCategoryEntity {
  final String id;
  final String nameAr;
  final String nameEn;
  final String image;
  bool? isFavorite;
  final bool? hasAuction;
  final int? numberOfContent;

  SubCategoryEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.image,
    this.isFavorite = false,
    this.hasAuction = false,
    this.numberOfContent,
  });
}
