class CarpoolTripParam {
  final String id;
  final String ownerId;
  final String? subcategoryId;
  final int seats;
  final String? driverId;
  final String? driverStatus;
  final bool womenDriverOnly;
  final bool womenOnly;
  final bool comfort;
  final String? tripStatus;
  final double priceForEveryUser;
  final double priceForDriver;
  final int duration;
  final int distance;
  final String? polyline;
  final DateTime expireAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CarpoolLocation> locations;

  CarpoolTripParam({
    required this.id,
    required this.ownerId,
    this.subcategoryId,
    required this.seats,
    this.driverId,
    this.driverStatus,
    required this.womenDriverOnly,
    required this.womenOnly,
    required this.comfort,
    this.tripStatus,
    required this.priceForEveryUser,
    required this.priceForDriver,
    required this.duration,
    required this.distance,
    this.polyline,
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
  final String? locationTitle; // Nullable
  final LocationCoordinates coordinates;
  final bool comfort;
  final bool booked;
  final String? otp; // Nullable
  final bool verifiedOtp;
  final String? gender; // Nullable
  final String? tripStatusForUser; // Nullable
  final BookedUser? bookedUser; // Nullable

  CarpoolLocation({
    required this.id,
    required this.carpoolId,
    required this.type,
    this.locationTitle,
    required this.coordinates,
    required this.comfort,
    required this.booked,
    this.otp,
    required this.verifiedOtp,
    this.gender,
    this.tripStatusForUser,
    this.bookedUser,
  });
}

class LocationCoordinates {
  final double? latitude;
  final double? longitude;

  LocationCoordinates({this.latitude, this.longitude});
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
