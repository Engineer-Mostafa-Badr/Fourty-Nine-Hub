class TripByUserModel {
  bool? adminIgnore;
  String? id;
  dynamic driverId;
  String? userId;
  String? categoryId;
  String? startLocation;
  String? targetLocation;
  String? status;
  double? price;
  String? time;
  String? desc;
  bool? isPremium;
  int? phone;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? driverRatingsVirtual;

  TripByUserModel({
    this.adminIgnore,
    this.id,
    this.driverId,
    this.userId,
    this.categoryId,
    this.startLocation,
    this.targetLocation,
    this.status,
    this.price,
    this.time,
    this.desc,
    this.isPremium,
    this.phone,
    this.createdAt,
    this.updatedAt,
    this.driverRatingsVirtual,
  });

  factory TripByUserModel.fromJson(Map<String, dynamic> json) {
    return TripByUserModel(
      adminIgnore: json['adminIgnore'] as bool?,
      driverId: json['driverId'] as dynamic,
      userId: json['userId'] as String?,
      categoryId: json['categoryId'] as String?,
      startLocation: json['startLocation'] as String?,
      targetLocation: json['targetLocation'] as String?,
      status: json['status'] as String?,
      price: double.parse(json['price'].toString()),
      time: json['time'] as String?,
      desc: json['desc'] as String?,
      isPremium: json['isPremium'] as bool?,
      phone: json['phone'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      driverRatingsVirtual: json['driverRatingsVirtual'] as List<dynamic>?,
      id: json['_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'adminIgnore': adminIgnore,
        'driverId': driverId,
        'userId': userId,
        'categoryId': categoryId,
        'startLocation': startLocation,
        'targetLocation': targetLocation,
        'status': status,
        'price': price,
        'time': time,
        'desc': desc,
        'isPremium': isPremium,
        'phone': phone,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'driverRatingsVirtual': driverRatingsVirtual,
        'id': id,
      };
}
