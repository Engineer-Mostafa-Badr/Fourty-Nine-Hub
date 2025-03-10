import 'package:fourtyninehub/features/RideFeature/domain/entities/create_loading_trip_entity.dart';

class CreateLoadingTripModel extends CreateLoadingTripEntity {
  CreateLoadingTripModel(
      {required super.driverId,
      required super.userId,
      required super.categoryId,
      required super.startLocation,
      required super.targetLocation,
      required super.status,
      required super.price,
      required super.time,
      required super.desc,
      required super.isPremium,
      required super.adminIgnore,
      required super.phone,
      required super.rate,
      required super.sId,
      required super.id});

  factory CreateLoadingTripModel.fromJson(Map<String, dynamic> json) {
    return CreateLoadingTripModel(
      driverId: json['driverId'],
      userId: json['userId'],
      categoryId: json['categoryId'],
      startLocation: json['startLocation'],
      targetLocation: json['targetLocation'],
      status: json['status'],
      price: json['price'],
      time: json['time'],
      desc: json['desc'],
      isPremium: json['isPremium'],
      adminIgnore: json['adminIgnore'],
      phone: json['phone'],
      rate: json['rate'],
      sId: json['_id'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driverId'] = driverId;
    data['userId'] = userId;
    data['categoryId'] = categoryId;
    data['startLocation'] = startLocation;
    data['targetLocation'] = targetLocation;
    data['status'] = status;
    data['price'] = price;
    data['time'] = time;
    data['desc'] = desc;
    data['isPremium'] = isPremium;
    data['adminIgnore'] = adminIgnore;
    data['phone'] = phone;
    data['rate'] = rate;
    data['_id'] = sId;
    data['id'] = id;
    return data;
  }
}
