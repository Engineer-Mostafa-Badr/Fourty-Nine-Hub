class ReviewEntity {
  final String id;
  final String name;
  final String? image;
  final String comment;
  final num rate;
  final String createdAt;

  ReviewEntity(
      {required this.id,
      required this.name,
      required this.comment,
      this.image, 
      required this.rate,
      required this.createdAt});
}
