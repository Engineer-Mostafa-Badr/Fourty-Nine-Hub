class ExpectedPriceEntity {
  final bool status;
  final num price;
  final num distance;
  final num duration;


  ExpectedPriceEntity(
      {this.status = true,
      required this.price,
      required this.distance,
      required this.duration});
}
