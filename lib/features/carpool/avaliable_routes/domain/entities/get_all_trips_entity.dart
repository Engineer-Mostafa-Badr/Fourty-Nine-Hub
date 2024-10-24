class CarpoolTripParam {
  final String id;
  final String ownerId;
  final int seats;
  final String? driverId;
  final String driverStatus;
  final bool womenDriverOnly;
  final bool womenOnly;
  final bool comfort;
  final String tripStatus;
  final int priceForEveryUser;
  final int priceForDriver;
  final int duration; // In seconds
  final int distance; // In meters
  final DateTime expireAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CarpoolLocation> locations;

  CarpoolTripParam({
    required this.id,
    required this.ownerId,
    required this.seats,
    this.driverId,
    required this.driverStatus,
    required this.womenDriverOnly,
    required this.womenOnly,
    required this.comfort,
    required this.tripStatus,
    required this.priceForEveryUser,
    required this.priceForDriver,
    required this.duration,
    required this.distance,
    required this.expireAt,
    required this.createdAt,
    required this.updatedAt,
    required this.locations,
  });
}

class CarpoolLocation {
  final String id;
  final String carpoolId;
  final String type;
  final String locationTitle;
  final LocationCoordinates coordinates;
  final bool comfort;
  final bool booked;
  final BookedUser? bookedUser;

  CarpoolLocation({
    required this.id,
    required this.carpoolId,
    required this.type,
    required this.locationTitle,
    required this.coordinates,
    required this.comfort,
    required this.booked,
    this.bookedUser,
  });
}

class LocationCoordinates {
  final double? latitude;
  final double? longitude;

  LocationCoordinates({
    required this.latitude,
    required this.longitude,
  });
}

class BookedUser {
  final String id;
  final String firstName;
  final String lastName;
  final String gender;

  BookedUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
  });
}
