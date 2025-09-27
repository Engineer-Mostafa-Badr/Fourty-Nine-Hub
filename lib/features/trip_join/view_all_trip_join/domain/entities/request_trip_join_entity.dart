class GetRequestTripJoinEntity {
  final String? id;
  final String? userId;
  final String? firstName;
  final String? requestType;
  final double? pricePerSeat;
  final String? startDate;
  final String? createdAt;
  final bool? isPremium;
  bool? isRead;
  final String? gender;
  final int? totalPassengers;
  final int? views;
  final String? phoneNumber;
  final IsButtonEnabledEntity? isButtonEnabled;
  final LocationEntity? location;

  GetRequestTripJoinEntity({
    this.id,
    this.userId,
    this.requestType,
    this.firstName,
    this.pricePerSeat,
    this.startDate,
    this.createdAt,
    this.isPremium,
    this.isRead,
    this.gender,
    this.totalPassengers,
    this.views,
    this.phoneNumber,
    this.isButtonEnabled,
    this.location,
  });
}

class IsButtonEnabledEntity {
  final bool? state;

  IsButtonEnabledEntity({this.state});
}

class LocationEntity {
  final AddressEntity? start;
  final AddressEntity? target;

  LocationEntity({this.start, this.target});
}

class AddressEntity {
  final String? address;
  final List<double>? coordinates;

  AddressEntity({this.address, this.coordinates});
}
