class CreatePricePerSeatEntity {
  final num basePricePerSeatWithoutFeatures;
  final num finalPricePerSeat;
  final num totalDistance;
  final String originAddress;
  final String destinationAddress;
  final List<List<double>> polyline;
  num? ladyDriverFee;
  num? ladyPassengerFee;
  num? comfortFee;

  CreatePricePerSeatEntity({required this.basePricePerSeatWithoutFeatures, required this.finalPricePerSeat, required this.totalDistance, required this.originAddress, required this.destinationAddress, required this.polyline,this.comfortFee,this.ladyDriverFee,this.ladyPassengerFee});
}