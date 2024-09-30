class TripInfo {
  String? id;
  String? userId;
  String? categoryId;
  String? vehicleId;
  String? fromAr;
  String? toAr;
  String? fromEn;
  String? toEn;
  int? distance;
  int? duration;
  int? passengers;
  int? price;
  String? phone;
  int? time;
  String? countryCode;
  List<dynamic>? calls;
  bool? isRepeat;
  String? status;
  bool? adminIgnore;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? countRequests;

  TripInfo({
    this.id,
    this.userId,
    this.categoryId,
    this.vehicleId,
    this.fromAr,
    this.toAr,
    this.fromEn,
    this.toEn,
    this.distance,
    this.duration,
    this.passengers,
    this.price,
    this.phone,
    this.time,
    this.countryCode,
    this.calls,
    this.isRepeat,
    this.status,
    this.adminIgnore,
    this.createdAt,
    this.updatedAt,
    this.countRequests,
  });

  @override
  String toString() {
    return 'TripInfo(id: $id, userId: $userId, categoryId: $categoryId, vehicleId: $vehicleId, fromAr: $fromAr, toAr: $toAr, fromEn: $fromEn, toEn: $toEn, distance: $distance, duration: $duration, passengers: $passengers, price: $price, phone: $phone, time: $time, countryCode: $countryCode, calls: $calls, isRepeat: $isRepeat, status: $status, adminIgnore: $adminIgnore, createdAt: $createdAt, updatedAt: $updatedAt, countRequests: $countRequests)';
  }

  factory TripInfo.fromJson(Map<String, dynamic> json) => TripInfo(
        id: json['_id'] as String?,
        userId: json['userId'] as String?,
        categoryId: json['categoryId'] as String?,
        vehicleId: json['vehicleId'] as String?,
        fromAr: json['fromAr'] as String?,
        toAr: json['toAr'] as String?,
        fromEn: json['fromEn'] as String?,
        toEn: json['toEn'] as String?,
        distance: json['distance'] as int?,
        duration: json['duration'] as int?,
        passengers: json['passengers'] as int?,
        price: json['price'] as int?,
        phone: json['phone'] as String?,
        time: json['time'] as int?,
        countryCode: json['countryCode'] as String?,
        calls: json['calls'] as List<dynamic>?,
        isRepeat: json['isRepeat'] as bool?,
        status: json['status'] as String?,
        adminIgnore: json['adminIgnore'] as bool?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        countRequests: json['countRequests'] as int?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId,
        'categoryId': categoryId,
        'vehicleId': vehicleId,
        'fromAr': fromAr,
        'toAr': toAr,
        'fromEn': fromEn,
        'toEn': toEn,
        'distance': distance,
        'duration': duration,
        'passengers': passengers,
        'price': price,
        'phone': phone,
        'time': time,
        'countryCode': countryCode,
        'calls': calls,
        'isRepeat': isRepeat,
        'status': status,
        'adminIgnore': adminIgnore,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'countRequests': countRequests,
      };
}
