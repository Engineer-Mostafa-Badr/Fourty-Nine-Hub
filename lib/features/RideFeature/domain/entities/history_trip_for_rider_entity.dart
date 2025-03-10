class HistoryTripForRiderEntity {
  final Location? startLocation;
  final Location? targetLocation;
  final String? id;
  final User? userId;
  final Rider? riderId;
  final Category? subCategoryId;
  final String? fromTitle;
  final String? toTitle;
  final int? profit;
  final bool? autoAccept;
  final bool? isPremium;
  final int? distance;
  final int? duration;
  final int? passengers;
  final int? price;
  final int? calculateB;
  final String? paymentMethod;
  final String? status;
  final int? penalty;
  final bool? payedPenalty;
  final bool? isUserGetCashback;
  final bool? isRiderGetCashback;
  final String? otp;
  final bool? freeTripForDriver;
  final dynamic? holdMoneyForTrip;
  final String? recordingVoice;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? startTime;
  final String? rate;
  final DateTime? expireAt;
  HistoryTripForRiderEntity({
    this.startLocation,
    this.targetLocation,
    this.id,
    this.userId,
    this.riderId,
    this.subCategoryId,
    this.fromTitle,
    this.toTitle,
    this.profit,
    this.autoAccept,
    this.isPremium,
    this.distance,
    this.duration,
    this.passengers,
    this.price,
    this.calculateB,
    this.paymentMethod,
    this.status,
    this.penalty,
    this.payedPenalty,
    this.isUserGetCashback,
    this.isRiderGetCashback,
    this.otp,
    this.freeTripForDriver,
    this.holdMoneyForTrip,
    this.recordingVoice,
    this.createdAt,
    this.updatedAt,
    this.startTime,
    this.rate,
    this.expireAt,
  });
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({required this.type, required this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: List<double>.from(json['coordinates'].map((x) => x.toDouble())),
    );
  }
}

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;

  User({required this.id, required this.firstName, required this.lastName, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
    );
  }
}

class Rider {
  final String id;
  final User userId;
  final String phone;

  Rider({required this.id, required this.userId, required this.phone});

  factory Rider.fromJson(Map<String, dynamic> json) {
    return Rider(
      id: json['_id'],
      userId: User.fromJson(json['userId']),
      phone: json['phone'],
    );
  }
}

class Category {
  final String id;
  final String nameAr;
  final String nameEn;

  Category({required this.id, required this.nameAr, required this.nameEn});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
    );
  }
}
