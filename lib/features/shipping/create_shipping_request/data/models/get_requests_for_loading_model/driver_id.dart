import 'driver_car.dart';
import 'user_id.dart';

class DriverId {
  String? id;
  UserId? userId;
  int? trips;
  String? location;
  String? phone;
  int? rating;
  List<DriverCar>? driverCar;

  DriverId({
    this.id,
    this.userId,
    this.trips,
    this.location,
    this.phone,
    this.rating,
    this.driverCar,
  });

  factory DriverId.fromJson(Map<String, dynamic> json) => DriverId(
        userId: json['userId'] == null
            ? null
            : UserId.fromJson(json['userId'] as Map<String, dynamic>),
        trips: json['trips'] as int?,
        location: json['location'] as String?,
        phone: json['phone'] as String?,
        rating: json['rating'] as int?,
        driverCar: (json['DRIVER_CAR'] as List<dynamic>?)
            ?.map((e) => DriverCar.fromJson(e as Map<String, dynamic>))
            .toList(),
        id: json['id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'userId': userId?.toJson(),
        'trips': trips,
        'location': location,
        'phone': phone,
        'rating': rating,
        'DRIVER_CAR': driverCar?.map((e) => e.toJson()).toList(),
        'id': id,
      };
}
