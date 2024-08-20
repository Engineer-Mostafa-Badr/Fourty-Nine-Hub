class SubCategoryEntity {
  final String id;
  final String name;
  final String image;
  final bool isFavorite;
  final int? numberOfContent;

  SubCategoryEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.isFavorite,
    this.numberOfContent,
  });
}
