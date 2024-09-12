
class FavouriteCategoryEntity {
  final String id;
  final String banner;
  final String cover;
  final String name;
  final num numberOfAds;
  bool? isFavorite;

  FavouriteCategoryEntity({required this.id, required this.banner, required this.cover, required this.name, required this.numberOfAds,this.isFavorite=false});

}
