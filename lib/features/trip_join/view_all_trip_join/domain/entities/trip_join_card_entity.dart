// ignore_for_file: public_member_api_docs, sort_constructors_first
class TripJoinCardEntity {
  String? brand;
  String? model;
  num? price;
  String? status;
  int? seatNumber;
  bool? isRepeated;
  String? startingAddress;
  String? destinationAddress;
  bool? isActive;
  DateTime? publishDate;
  TripJoinCardEntity({
    this.brand,
    this.model,
    this.price,
    this.status,
    this.seatNumber,
    this.isRepeated,
    this.startingAddress,
    this.destinationAddress,
    this.isActive,
    this.publishDate,
  });

  TripJoinCardEntity copyWith({
    String? brand,
    String? model,
    num? price,
    String? status,
    int? seatNumber,
    bool? isRepeated,
    String? startingAddress,
    String? locationAddress,
    bool? isActive,
    DateTime? publishDate,
  }) {
    return TripJoinCardEntity(
      brand: brand ?? this.brand,
      model: model ?? this.model,
      price: price ?? this.price,
      status: status ?? this.status,
      seatNumber: seatNumber ?? this.seatNumber,
      isRepeated: isRepeated ?? this.isRepeated,
      startingAddress: startingAddress ?? this.startingAddress,
      destinationAddress: locationAddress ?? destinationAddress,
      isActive: isActive ?? this.isActive,
      publishDate: publishDate ?? this.publishDate,
    );
  }

  @override
  String toString() {
    return 'TripJoinCardEntity(brand: $brand, model: $model, price: $price, status: $status, seatNumber: $seatNumber, isRepeated: $isRepeated, startingAddress: $startingAddress, destinationAddress: $destinationAddress, isActive: $isActive, publishDate: $publishDate)';
  }
}
