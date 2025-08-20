import '../../../domain/entities/request_trip_join_entity.dart';

class GetRequestTripJoinModel extends GetRequestTripJoinEntity {
  GetRequestTripJoinModel({
    super.id,
    super.userId,
    super.firstName,
    super.pricePerSeat,
    super.startDate,
    super.createdAt,
    super.isPremium,
    super.isRead,
    super.gender,
    super.totalPassengers,
    super.views,
    super.phoneNumber,
    IsButtonEnabledModel? super.isButtonEnabled,
    LocationModel? super.location,
  });

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
  IsButtonEnabledModel({super.state});

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
  AddressModel({super.address, super.coordinates});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      address: json['address'] as String?,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((coord) => (coord as num).toDouble())
          .toList(),
    );
  }
}
