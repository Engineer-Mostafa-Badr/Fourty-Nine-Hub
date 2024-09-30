class FavouriteSubcategoryEntity {
  final String id;
  final String picture;
  final String nameEn;
  final String nameAr;
  final int numOfAds;
  bool? isFavorite;

  FavouriteSubcategoryEntity(
      {required this.id,
      required this.picture,
      required this.nameEn,
      required this.nameAr,
      required this.numOfAds,
      this.isFavorite = false});
}
