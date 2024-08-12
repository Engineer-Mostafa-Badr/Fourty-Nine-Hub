import '../../../../res/style/const.dart';
import '../../domain/entities/driver_entity.dart';

class DriverModel extends DriverEntity {
  DriverModel(
      {required super.id,
      required super.name,
      required super.phone,
      required super.email,
      required super.profileImage,
      required super.carSign,
      required super.carImage,
      required super.rate,
      required super.location,
      required super.numberOfReviews});

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      profileImage: json['profile_image'] ?? UIConst.profilePlaceHolder,
      carSign: json['car_sign'],
      carImage: json['car_image'],
      rate: json['rate'],
      numberOfReviews: json['number_of_reviews'],
      location: json['location'].cast<double>(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['car_sign'] = carSign;
    data['car_image'] = carImage;
    data['rate'] = rate;
    data['number_of_reviews'] = numberOfReviews;
    return data;
  }
}
