// ignore_for_file: public_member_api_docs, sort_constructors_first
class TripJoinCardEntity {
  String? id;
  String? userId;
  String? categoryId;
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
  String? phone;
  TripJoinCardEntity({
    this.id,
    this.userId,
    this.categoryId,
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
    this.phone,
  });

  TripJoinCardEntity copyWith({
    String? id,
    String? userId,
    String? categoryId,
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
    String? phone,
  }) {
    return TripJoinCardEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
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
      phone: phone ?? this.phone,
    );
  }

  @override
  String toString() {
    return 'TripJoinCardEntity(id: $id, userId: $userId, categoryId: $categoryId, brand: $brand, model: $model, journeyPrice: $journeyPrice, status: $status, seatNumber: $seatNumber, isRepeated: $isRepeated, startingAddressAr: $startingAddressAr, destinationAddressAr: $destinationAddressAr, startingAddressEn: $startingAddressEn, destinationAddressEn: $destinationAddressEn, isApproved: $isApproved, publishDate: $publishDate, phone: $phone)';
  }
}
