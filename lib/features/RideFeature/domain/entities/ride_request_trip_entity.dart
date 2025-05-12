class RideRequestTripEntity {
  final String? id;
  final String? userId;
  final String? riderId;
  final String? subCategoryId;
  final String? carTypeId;
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
  final bool? isUserGetCashback;
  final bool? isRiderGetCashback;
  final bool? freeTripForDriver;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? expireAt;
  final double? rating;
  final double? driverIsArrivingIn;
  final String? driverId;
  final String? driverUserId;
  final String? driverFirstName;
  final String? driverProfilePicture;
  final String? driverPhoneNumber;
  final double? driverRating;
  final int? driverRatingCount;
  final String? vehicleModel;
  final String? vehicleColor;
  final String? vehicleBrand;
  final String? vehiclePicture;
  final String? vehiclePlateNumber;
  final List<List<double>> polyline;
  final String? otp;

  RideRequestTripEntity({required this.id, required this.userId, required this.riderId, required this.subCategoryId, required this.carTypeId, required this.from, required this.to, required this.wayPointOneTitle, required this.wayPointTwoTitle, required this.wayPointOne, required this.wayPointTwo, required this.startCoordinates, required this.targetCoordinates, required this.distance, required this.duration, required this.passengers, required this.price, required this.lowestFare, required this.highestFare, required this.paymentMethod, required this.status, required this.autoAccept, required this.isPremium, required this.isUserGetCashback, required this.isRiderGetCashback, required this.freeTripForDriver, required this.createdAt, required this.updatedAt, required this.expireAt, required this.rating, required this.driverIsArrivingIn, required this.driverFirstName, required this.driverId,  required this.driverPhoneNumber, required this.driverProfilePicture,  required this.driverRating, required this.driverRatingCount, required this.vehicleModel, required this.vehicleColor, required this.vehicleBrand, required this.vehiclePicture, required this.vehiclePlateNumber,  required this.driverUserId, required this.polyline, required this.otp});

  RideRequestTripEntity copyWith({
    String? id,
    String? userId,
    String? riderId,
    String? subCategoryId,
    String? carTypeId,
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
    bool? isUserGetCashback,
    bool? isRiderGetCashback,
    bool? freeTripForDriver,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? expireAt,
    double? rating,
    double? driverIsArrivingIn,
    String? driverId,
    String? driverUserId,
    String? driverFirstName,
    String? driverProfilePicture,
    String? driverPhoneNumber,
    double? driverRating,
    int? driverRatingCount,
    String? vehicleModel,
    String? vehicleColor,
    String? vehicleBrand,
    String? vehiclePicture,
    String? vehiclePlateNumber,
    List<List<double>>? polyline,
    String? otp,
  }) {
    return RideRequestTripEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      riderId: riderId ?? this.riderId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      carTypeId: carTypeId ?? this.carTypeId,
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
      isUserGetCashback: isUserGetCashback ?? this.isUserGetCashback,
      isRiderGetCashback: isRiderGetCashback ?? this.isRiderGetCashback,
      freeTripForDriver: freeTripForDriver ?? this.freeTripForDriver,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      expireAt: expireAt ?? this.expireAt,
      rating: rating ?? this.rating,
      driverIsArrivingIn: driverIsArrivingIn ?? this.driverIsArrivingIn,
      driverId: driverId ?? this.driverId,
      driverUserId: driverUserId ?? this.driverUserId,
      driverFirstName: driverFirstName ?? this.driverFirstName,
      driverProfilePicture: driverProfilePicture ?? this.driverProfilePicture,
      driverPhoneNumber: driverPhoneNumber ?? this.driverPhoneNumber,
      driverRating: driverRating ?? this.driverRating,
      driverRatingCount: driverRatingCount ?? this.driverRatingCount,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleColor: vehicleColor ?? this.vehicleColor,
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      vehiclePicture: vehiclePicture ?? this.vehiclePicture,
      vehiclePlateNumber: vehiclePlateNumber ?? this.vehiclePlateNumber,
      polyline: polyline ?? this.polyline,
      wayPointOne: wayPointOne ?? wayPointOne,
      wayPointTwo: wayPointTwo ?? wayPointTwo, wayPointOneTitle: wayPointOneTitle ?? wayPointOneTitle, wayPointTwoTitle: wayPointTwoTitle ?? wayPointTwoTitle,
      otp: otp ?? this.otp
    );
  }
}