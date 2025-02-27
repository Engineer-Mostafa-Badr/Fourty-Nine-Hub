class RunningTripsEntity {
  final String id;
  final String from;
  final String to;
  final String categoryPicture;
  final String categoryNameEn;
  final String categoryNameAr;
  final String carPicture;
  final String address;
  final DateTime createdAt;
  final int price;
  final String status;
  final String currencyEn;
  final String currencyAr;
  final String? rating;
  final String car;
  final String gender;

  RunningTripsEntity({
    required this.id,
    required this.from,
    required this.to,
    required this.categoryPicture,
    required this.categoryNameEn,
    required this.categoryNameAr,
    required this.carPicture,
    required this.address,
    required this.createdAt,
    required this.price,
    required this.status,
    required this.currencyEn,
    required this.currencyAr,
    this.rating,
    required this.car,
    required this.gender,
  });
}