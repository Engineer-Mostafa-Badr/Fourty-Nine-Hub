class SubCategoryEntity {
  final String id;
  final String name;
  final String image;
  bool? isFavorite;
  final int? numberOfContent;

  SubCategoryEntity({
    required this.id,
    required this.name,
    required this.image,
    this.isFavorite = false,
    this.numberOfContent,
  });
}
