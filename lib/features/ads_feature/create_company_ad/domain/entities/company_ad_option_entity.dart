class CompanyAdOptionEntity {
  final String userId;
  final String advertisementType;
  final String post;
  final num totalPrice;
  final bool isApproved;
  final String endAt;
  final String type;
  final String id;
  final String createdAt;

  CompanyAdOptionEntity(
      {required this.userId,
      required this.advertisementType,
      required this.post,
      required this.totalPrice,
      required this.isApproved,
      required this.endAt,
      required this.type,
      required this.id,
      required this.createdAt});
}
