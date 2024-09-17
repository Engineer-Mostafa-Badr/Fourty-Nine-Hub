// ignore_for_file: public_member_api_docs, sort_constructors_first
class TripJoinRequestEntity {
  String? id;
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
  int? subscriptionEndDate;
  int? publishDate;
  String? paymentMethod;
  bool? subscribedPremium;
  TripJoinRequestEntity({
    this.id,
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
    this.subscriptionEndDate,
    this.publishDate,
    this.paymentMethod,
    this.subscribedPremium,
  });

  @override
  String toString() {
    return 'TripjoinRequestEntity(id: $id, categoryId: $categoryId, brand: $brand, model: $model, journeyPrice: $journeyPrice, status: $status, seatNumber: $seatNumber, isRepeated: $isRepeated, startingAddressAr: $startingAddressAr, destinationAddressAr: $destinationAddressAr, startingAddressEn: $startingAddressEn, destinationAddressEn: $destinationAddressEn, subscriptionEndDate: $subscriptionEndDate, publishDate: $publishDate, paymentMethod: $paymentMethod, subscribedPremium: $subscribedPremium)';
  }
}
