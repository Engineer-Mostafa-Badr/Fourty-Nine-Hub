// ignore_for_file: public_member_api_docs, sort_constructors_first
class TripJoinCardEntity {
  String? brand;
  String? model;
  num? journeyPrice;
  String? status;
  int? seatNumber;
  bool? isRepeated;
  String? startingAddressAr;
  String? destinationAddressAr;
  String? startingAddressEn;
  String? destinationAddressEn;
  bool? isApproved;
  int? publishDate;
  TripJoinCardEntity({
    this.brand,
    this.model,
    this.journeyPrice,
    this.status,
    this.seatNumber,
    this.isRepeated,
    this.startingAddressAr,
    this.destinationAddressAr,
    this.startingAddressEn,
    this.destinationAddressEn,
    this.isApproved,
    this.publishDate,
  });

  TripJoinCardEntity copyWith({
    String? brand,
    String? model,
    num? journeyPrice,
    String? status,
    int? seatNumber,
    bool? isRepeated,
    String? startingAddressAr,
    String? destinationAddressAr,
    String? startingAddressEn,
    String? destinationAddressEn,
    bool? isApproved,
    int? publishDate,
  }) {
    return TripJoinCardEntity(
      brand: brand ?? this.brand,
      model: model ?? this.model,
      journeyPrice: journeyPrice ?? this.journeyPrice,
      status: status ?? this.status,
      seatNumber: seatNumber ?? this.seatNumber,
      isRepeated: isRepeated ?? this.isRepeated,
      startingAddressAr: startingAddressAr ?? this.startingAddressAr,
      destinationAddressAr: destinationAddressAr ?? this.destinationAddressAr,
      startingAddressEn: startingAddressEn ?? this.startingAddressEn,
      destinationAddressEn: destinationAddressEn ?? this.destinationAddressEn,
      isApproved: isApproved ?? this.isApproved,
      publishDate: publishDate ?? this.publishDate,
    );
  }

  @override
  String toString() {
    return 'TripJoinCardEntity(brand: $brand, model: $model, journeyPrice: $journeyPrice, status: $status, seatNumber: $seatNumber, isRepeated: $isRepeated, startingAddressAr: $startingAddressAr, destinationAddressAr: $destinationAddressAr, startingAddressEn: $startingAddressEn, destinationAddressEn: $destinationAddressEn, isApproved: $isApproved, publishDate: $publishDate)';
  }
}
