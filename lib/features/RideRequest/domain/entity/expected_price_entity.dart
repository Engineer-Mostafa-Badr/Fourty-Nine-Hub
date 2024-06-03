class ExpectedPriceEntity {
  final bool status;
  final int price;
  final int distance;
  final int duration;


  String get displayedDistance => '${distance/1000} km';
  String get displayedTime =>'${duration/60} hr';
  ExpectedPriceEntity(
      { this.status = true,
      required this.price,
      required this.distance,
      required this.duration});

  
}
