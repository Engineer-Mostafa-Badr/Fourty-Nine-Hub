import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/request_trip_join_entity.dart';

class GetRequestTripJoinModel extends GetRequestTripJoinEntity {
  GetRequestTripJoinModel({
    String? id,
    String? userId,
    String? firstName,
    double? pricePerSeat,
    String? startDate,
    bool? isPremium,
    bool? isRead,
    String? gender,
    IsButtonEnabledModel? isButtonEnabled,
    LocationModel? location,
  }) : super(
    id: id,
    userId: userId,
    firstName: firstName,
    pricePerSeat: pricePerSeat,
    startDate: startDate,
    isPremium: isPremium,
    isRead: isRead,
    gender: gender,
    isButtonEnabled: isButtonEnabled,
    location: location,
  );

  factory GetRequestTripJoinModel.fromJson(Map<String, dynamic> json) {
    return GetRequestTripJoinModel(
      id: json['id'],
      userId: json['userId'],
      firstName: json['firstName'],
      pricePerSeat: (json['pricePerSeat'] as num?)?.toDouble(),
      startDate: json['startDate'] ,
      isPremium: json['isPremium'],
      isRead: json['isRead'],
      gender: json['gender'],
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
      state: json['state'],
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
      address: json['address'],
      coordinates: (json['coordinates'] as List?)
          ?.map((coord) => (coord as num).toDouble())
          .toList(),
    );
  }
}
