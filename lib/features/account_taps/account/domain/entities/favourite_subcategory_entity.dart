class FavouriteSubcategoryEntity {
  final String id;
  final String picture;
  final String name;
  bool? isFavorite;

  FavouriteSubcategoryEntity(
      {required this.id,
      required this.picture,
      required this.name,
      this.isFavorite = false});
}
