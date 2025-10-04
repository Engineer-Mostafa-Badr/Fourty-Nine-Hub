import 'package:fourtyninehub/features/trip_join/view_all_trip_join/data/models/trip_join_card_model/available_trip_join_model.dart';

import '../../../domain/entities/request_trip_join_entity.dart';

class GetRequestTripJoinModel extends GetRequestTripJoinEntity {
  GetRequestTripJoinModel({
    super.id,
    super.userId,
    super.requestType,
    super.firstName,
    super.pricePerSeat,
    super.startDate,
    super.createdAt,
    super.isPremium,
    super.lastViewers,
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
      requestType: json['requestType'] as String?,
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
      lastViewers:  (json['lastViewers'] as List<dynamic>?)
          ?.map((e) => ViewerModel.fromJson(e))
          .toList(),
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
          ?.map((coord) => ((coord??0) as num).toDouble())
          .toList(),
    );
  }
}
