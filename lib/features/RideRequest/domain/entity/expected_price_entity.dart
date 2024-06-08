class ExpectedPriceEntity {
  final bool status;
  final num price;
  final String distance;
  final String duration;


  ExpectedPriceEntity(
      {this.status = true,
      required this.price,
      required this.distance,
      required this.duration});
}
