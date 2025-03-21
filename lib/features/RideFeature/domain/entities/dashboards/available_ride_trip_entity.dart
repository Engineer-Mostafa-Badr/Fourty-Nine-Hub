class AvailableRideTripEntity {
  final String id;
  final bool isAutoAccept;
  final bool isPremium;
  final num price;
  final String paymentMethod;
  final num passengers;
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

  AvailableRideTripEntity({required this.id, required this.isAutoAccept, required this.isPremium, required this.price, required this.paymentMethod, required this.passengers, required this.fromAddress, required this.toAddress, required this.subcategoryId, required this.subcategoryImage, required this.subcategoryNameEn, required this.subcategoryNameAr, required this.clientId, required this.clientImage, required this.clientName, required this.clientGender, required this.clientRatingCount,required this.clientRatingAverage, required this.createdAt, required this.isButtonEnabled});
}