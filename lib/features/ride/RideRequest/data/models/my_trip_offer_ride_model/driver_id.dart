import 'location.dart';
import 'review.dart';
import 'user_id.dart';

class DriverId {
  Location? location;
  String? id;
  UserId? userId;
  String? phone;
  Review? review;

  DriverId({this.location, this.id, this.userId, this.phone, this.review});

  factory DriverId.fromJson(Map<String, dynamic> json) => DriverId(
        location: json['location'] == null
            ? null
            : Location.fromJson(json['location'] as Map<String, dynamic>),
        id: json['_id'] as String?,
        userId: json['userId'] == null
            ? null
            : UserId.fromJson(json['userId'] as Map<String, dynamic>),
        phone: json['phone'] as String?,
        review: json['review'] == null
            ? null
            : Review.fromJson(json['review'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'location': location?.toJson(),
        '_id': id,
        'userId': userId?.toJson(),
        'phone': phone,
        'review': review?.toJson(),
      };
}
