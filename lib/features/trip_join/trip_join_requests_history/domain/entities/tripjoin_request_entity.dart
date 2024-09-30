// ignore_for_file: public_member_api_docs, sort_constructors_first
class TripJoinMyRequestEntity {
  String? id;
  String? categoryMainId;
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
  bool? hasNextPage;
  int? nextPage;
  TripJoinMyRequestEntity({
    this.id,
    this.categoryMainId,
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
    this.hasNextPage,
    this.nextPage,
  });

  @override
  String toString() {
    return 'TripJoinRequestEntity(id: $id, categoryMainId: $categoryMainId, brand: $brand, model: $model, journeyPrice: $journeyPrice, status: $status, seatNumber: $seatNumber, isRepeated: $isRepeated, startingAddressAr: $startingAddressAr, destinationAddressAr: $destinationAddressAr, startingAddressEn: $startingAddressEn, destinationAddressEn: $destinationAddressEn, subscriptionEndDate: $subscriptionEndDate, publishDate: $publishDate, paymentMethod: $paymentMethod, subscribedPremium: $subscribedPremium, hasNextPage: $hasNextPage, nextPage: $nextPage)';
  }
}
