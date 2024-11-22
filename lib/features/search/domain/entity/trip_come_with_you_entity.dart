// ignore_for_file: public_member_api_docs, sort_constructors_first
class TripComeWithYouEntity {
  final String id;
  final String userId;
  final String userFirstName;
  final String userLastName;
  final String image;
  final String categoryId;
  final String categoryNameAr;
  final String categoryNameEn;
  final String vehicleId;
  final String vehicleModel;
  final String vehicleBrand;
  final String fromAr;
  final String toAr;
  final String fromEn;
  final String toEn;
  final int distance;
  final int duration;
  final int passengers;
  final int price;
  final String phone;
  final int time;
  final String countryCode;
  final int countRequests;
  final List<dynamic> calls;
  final bool isRepeat;
  final String status;
  final int statusPriority;
  final bool adminIgnore;
  final DateTime createdAt;
  final DateTime updatedAt;

  TripComeWithYouEntity(
      {required this.id,
      required this.userId,
      required this.userFirstName,
      required this.userLastName,
      required this.image,
      required this.categoryId,
      required this.categoryNameAr,
      required this.categoryNameEn,
      required this.vehicleId,
      required this.vehicleModel,
      required this.vehicleBrand,
      required this.fromAr,
      required this.toAr,
      required this.fromEn,
      required this.toEn,
      required this.distance,
      required this.duration,
      required this.passengers,
      required this.price,
      required this.phone,
      required this.time,
      required this.countryCode,
      required this.countRequests,
      required this.calls,
      required this.isRepeat,
      required this.status,
      required this.statusPriority,
      required this.adminIgnore,
      required this.createdAt,
      required this.updatedAt});
}
