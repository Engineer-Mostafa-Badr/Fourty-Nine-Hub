class AvailableRideTripEntity {
  final String id;
  bool? isAutoAccept;
  final bool isPremium;
  final bool isComfort;
  final bool isNonSmoking;
  num? price;
  final String paymentMethod;
  final num passengers;
  final num distance;
  final num duration;
  final String fromAddress;
  final String toAddress;
  final String subcategoryId;
  final String subcategoryImage;
  final String subcategoryNameEn;
  final String subcategoryNameAr;
  final String clientId;
  final String clientImage;
  final String clientName;
  final String clientGender;
  final num clientRatingCount;
  final num clientRatingAverage;
  final String createdAt;
  final bool isButtonEnabled;

  AvailableRideTripEntity({required this.id, this.isAutoAccept,required this.distance,required this.duration, required this.isPremium,required this.isComfort,required this.isNonSmoking, required this.price, required this.paymentMethod, required this.passengers, required this.fromAddress, required this.toAddress, required this.subcategoryId, required this.subcategoryImage, required this.subcategoryNameEn, required this.subcategoryNameAr, required this.clientId, required this.clientImage, required this.clientName, required this.clientGender, required this.clientRatingCount,required this.clientRatingAverage, required this.createdAt, required this.isButtonEnabled});
}