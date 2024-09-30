class FavouriteCategoryEntity {
  final String id;
  final String banner;
  final String cover;
  final String nameEn;
  final String nameAr;
  final num numberOfAds;
  bool? isFavorite;

  FavouriteCategoryEntity(
      {required this.id,
      required this.banner,
      required this.cover,
      required this.nameEn,
      required this.nameAr,
      required this.numberOfAds,
      this.isFavorite = false});
}
