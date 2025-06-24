// Entities
  class GetRequestTripJoinEntity {
  final String? id;
  final String? userId;
  final String? firstName;
  final double? pricePerSeat;
  final DateTime? startDate;
  final bool? isPremium;
  final bool? isRead;
  final LocationEntity? location;

  GetRequestTripJoinEntity({
  this.id,
  this.userId,
  this.firstName,
  this.pricePerSeat,
  this.startDate,
  this.isPremium,
  this.isRead,
  this.location,
  });
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