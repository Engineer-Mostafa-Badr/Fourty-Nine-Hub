class ReviewEntity {
  final int id;
  final String name;
  final String comment;
  final num rate;
  final String createdAt;

  ReviewEntity(
      {required this.id,
      required this.name,
      required this.comment,
      required this.rate,
      required this.createdAt});
}
