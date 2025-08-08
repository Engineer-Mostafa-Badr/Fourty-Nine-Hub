class RideRequestTripEntity {
  final String? id;
  final String? userId;
  final String? subCategoryId;
  final String? from;
  final String? to;
  final String? wayPointOneTitle;
  final String? wayPointTwoTitle;
  final List<double>? startCoordinates;
  final List<double>? targetCoordinates;
  final List<double>? wayPointOne;
  final List<double>? wayPointTwo;
  final double? distance;
  final int? duration;
  final int? passengers;
  double? price;
  double? lowestFare;
  double? highestFare;
  final String? paymentMethod;
  String? status;
  bool? autoAccept;
  final bool? isPremium;
  final DateTime? createdAt;
  final double? rating;
  final DateTime? driverIsArrivingIn;
  final DateTime? tripStartedAt;
  final String? driverId;
  final String? driverUserId;
  final String? driverFirstName;
  final String? driverProfilePicture;
  final String? driverPhoneNumber;
  final double? driverRating;
  final int? driverRatingCount;
  final String? vehicleModelAr;
  final String? vehicleModelEn;
  final String? vehicleColor;
  final String? vehicleBrandAr;
  final String? vehicleBrandEn;
  final String? vehiclePicture;
  final String? vehiclePlateNumber;
  final List<List<double>> polyline;
  final List<List<double>> driverPolyline;
  final double? driverStartLat;
  final double? driverStartLng;
  final double? driverTargetLat;
  final double? driverTargetLng;
  final String? otp;

  RideRequestTripEntity({required this.vehicleModelEn, required this.vehicleBrandEn, required this.id, required this.userId, required this.subCategoryId, required this.from, required this.to, required this.wayPointOneTitle, required this.wayPointTwoTitle, required this.wayPointOne, required this.wayPointTwo, required this.startCoordinates, required this.targetCoordinates, required this.distance, required this.duration, required this.passengers, required this.price, required this.lowestFare, required this.highestFare, required this.paymentMethod, required this.status, required this.autoAccept, required this.isPremium,  required this.createdAt, required this.rating, required this.driverIsArrivingIn, required this.driverFirstName, required this.driverId,  required this.driverPhoneNumber, required this.driverProfilePicture,  required this.driverRating, required this.driverRatingCount, required this.vehicleModelAr, required this.vehicleColor, required this.vehicleBrandAr, required this.vehiclePicture, required this.vehiclePlateNumber,  required this.driverUserId, required this.polyline, required this.driverPolyline, required this.driverStartLat, required this.driverStartLng, required this.driverTargetLat, required this.driverTargetLng, required this.otp, required this.tripStartedAt});

  RideRequestTripEntity copyWith({
    String? id,
    String? userId,
    String? subCategoryId,
    String? from,
    String? to,
    List<double>? startCoordinates,
    List<double>? targetCoordinates,
    double? distance,
    int? duration,
    int? passengers,
    double? price,
    double? lowestFare,
    double? highestFare,
    String? paymentMethod,
    String? status,
    bool? autoAccept,
    bool? isPremium,
    DateTime? createdAt,
    double? rating,
    DateTime? driverIsArrivingIn,
    DateTime? tripStartedAt,
    String? driverId,
    String? driverUserId,
    String? driverFirstName,
    String? driverProfilePicture,
    String? driverPhoneNumber,
    double? driverRating,
    int? driverRatingCount,
    String? vehicleModelAr,
    String? vehicleModelEn,
    String? vehicleColor,
    String? vehicleBrandAr,
    String? vehicleBrandEn,
    String? vehiclePicture,
    String? vehiclePlateNumber,
    List<List<double>>? polyline,
    List<List<double>>? driverPolyline,
    double? driverStartLat,
    double? driverStartLng,
    double? driverTargetLat,
    double? driverTargetLng,
    String? otp,
  }) {
    return RideRequestTripEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      from: from ?? this.from,
      to: to ?? this.to,
      startCoordinates: startCoordinates ?? this.startCoordinates,
      targetCoordinates: targetCoordinates ?? this.targetCoordinates,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      passengers: passengers ?? this.passengers,
      price: price ?? this.price,
      lowestFare: lowestFare ?? this.lowestFare,
      highestFare: highestFare ?? this.highestFare,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      autoAccept: autoAccept ?? this.autoAccept,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
      rating: rating ?? this.rating,
      driverIsArrivingIn: driverIsArrivingIn ?? this.driverIsArrivingIn,
      tripStartedAt: tripStartedAt ?? this.tripStartedAt,
      driverId: driverId ?? this.driverId,
      driverUserId: driverUserId ?? this.driverUserId,
      driverFirstName: driverFirstName ?? this.driverFirstName,
      driverProfilePicture: driverProfilePicture ?? this.driverProfilePicture,
      driverPhoneNumber: driverPhoneNumber ?? this.driverPhoneNumber,
      driverRating: driverRating ?? this.driverRating,
      driverRatingCount: driverRatingCount ?? this.driverRatingCount,
      vehicleModelAr: vehicleModelAr ?? this.vehicleModelAr,
      vehicleModelEn: vehicleModelEn ?? this.vehicleModelEn,
      vehicleColor: vehicleColor ?? this.vehicleColor,
      vehicleBrandAr: vehicleBrandAr ?? this.vehicleBrandAr,
      vehicleBrandEn: vehicleBrandEn ?? this.vehicleBrandEn,
      vehiclePicture: vehiclePicture ?? this.vehiclePicture,
      vehiclePlateNumber: vehiclePlateNumber ?? this.vehiclePlateNumber,
      polyline: polyline ?? this.polyline,
      wayPointOne: wayPointOne ?? wayPointOne,
      wayPointTwo: wayPointTwo ?? wayPointTwo, wayPointOneTitle: wayPointOneTitle ?? wayPointOneTitle, wayPointTwoTitle: wayPointTwoTitle ?? wayPointTwoTitle,
      driverPolyline: driverPolyline ?? this.driverPolyline,
      driverStartLat: driverStartLat ?? this.driverStartLat,
      driverStartLng: driverStartLng ?? this.driverStartLng,
      driverTargetLat: driverTargetLat ?? this.driverTargetLat,
      driverTargetLng: driverTargetLng ?? this.driverTargetLng,
      otp: otp ?? this.otp
    );
  }
}