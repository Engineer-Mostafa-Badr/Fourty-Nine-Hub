import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/request_trip_join_entity.dart';

class GetRequestTripJoinModel extends GetRequestTripJoinEntity {
  GetRequestTripJoinModel({
    String? id,
    String? userId,
    String? firstName,
    double? pricePerSeat,
    String? startDate,
    String? createdAt,
    bool? isPremium,
    bool? isRead,
    String? gender,
    int? totalPassengers,
    int? views,
    String? phoneNumber,
    IsButtonEnabledModel? isButtonEnabled,
    LocationModel? location,
  }) : super(
    id: id,
    userId: userId,
    firstName: firstName,
    pricePerSeat: pricePerSeat,
    startDate: startDate,
    createdAt: createdAt,
    isPremium: isPremium,
    isRead: isRead,
    gender: gender,
    totalPassengers: totalPassengers,
    views: views,
    phoneNumber: phoneNumber,
    isButtonEnabled: isButtonEnabled,
    location: location,
  );

  factory GetRequestTripJoinModel.fromJson(Map<String, dynamic> json) {
    return GetRequestTripJoinModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      firstName: json['firstName'] as String?,
      pricePerSeat: (json['pricePerSeat'] as num?)?.toDouble(),
      startDate: json['startDate'] as String?,
      createdAt: json['createdAt'] as String?,
      isPremium: json['isPremium'] as bool?,
      isRead: json['isRead'] as bool?,
      gender: json['gender'] as String?,
      totalPassengers: json['totalPassengers'] as int?,
      views: json['views'] as int?,
      phoneNumber: json['phoneNumber'] as String?,
      isButtonEnabled: json['isButtonEnabled'] != null
          ? IsButtonEnabledModel.fromJson(json['isButtonEnabled'])
          : null,
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
    );
  }
}

class IsButtonEnabledModel extends IsButtonEnabledEntity {
  IsButtonEnabledModel({bool? state}) : super(state: state);

  factory IsButtonEnabledModel.fromJson(Map<String, dynamic> json) {
    return IsButtonEnabledModel(
      state: json['state'] as bool?,
    );
  }
}

class LocationModel extends LocationEntity {
  LocationModel({AddressModel? start, AddressModel? target})
      : super(start: start, target: target);

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      start: json['start'] != null
          ? AddressModel.fromJson(json['start'])
          : null,
      target: json['target'] != null
          ? AddressModel.fromJson(json['target'])
          : null,
    );
  }
}

class AddressModel extends AddressEntity {
  AddressModel({String? address, List<double>? coordinates})
      : super(address: address, coordinates: coordinates);

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      address: json['address'] as String?,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((coord) => (coord as num).toDouble())
          .toList(),
    );
  }
}
