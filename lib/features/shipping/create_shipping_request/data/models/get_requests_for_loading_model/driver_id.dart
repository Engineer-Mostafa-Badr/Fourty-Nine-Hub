import 'driver_info_id.dart';
import 'review.dart';
import 'user_id.dart';

class DriverId {
  String? id;
  UserId? userId;
  DriverInfoId? driverInfoId;
  int? trips;
  String? location;
  String? phone;
  double? rating;
  Review? review;
  String? carModel;
  String? categoryId;
  DriverId({
    this.id,
    this.userId,
    this.driverInfoId,
    this.trips,
    this.location,
    this.phone,
    this.carModel,
    this.categoryId,
    this.rating,
    this.review,
  });

  factory DriverId.fromJson(Map<String, dynamic> json) => DriverId(
        userId: json['userId'] == null
            ? null
            : UserId.fromJson(json['userId'] as Map<String, dynamic>),
        driverInfoId: json['driverInfoId'] == null
            ? null
            : DriverInfoId.fromJson(
                json['driverInfoId'] as Map<String, dynamic>),
        trips: json['trips'] as int?,
        location: json['location'] as String?,
        phone: json['phone'] as String?,
        categoryId: json['categoryId'] as String?,
        carModel: json['carModel'] as String?,
        rating: (json['rating'] as num?)?.toDouble(),
        id: json['id'] as String?,
        review: json['review'] == null
            ? null
            : Review.fromJson(json['review'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId?.toJson(),
        'driverInfoId': driverInfoId?.toJson(),
        'trips': trips,
        'location': location,
        'phone': phone,
        'rating': rating,
        'id': id,
        'review': review?.toJson(),
      };
}
