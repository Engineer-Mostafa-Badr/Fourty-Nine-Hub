class DriverId {
  String? id;
  String? userId;
  String? driverInfoId;
  String? categoryId;
  String? carModel;
  String? firstName;
  String? lastName;
  bool? isActive;
  int? profit;
  int? trips;
  dynamic countryCode;
  String? location;
  String? phone;
  double? rating;
  bool? isApproved;
  bool? adminIgnore;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? numberOfReviewers;

  DriverId({
    this.id,
    this.userId,
    this.driverInfoId,
    this.categoryId,
    this.carModel,
    this.firstName,
    this.lastName,
    this.isActive,
    this.profit,
    this.trips,
    this.countryCode,
    this.location,
    this.phone,
    this.rating,
    this.isApproved,
    this.adminIgnore,
    this.createdAt,
    this.updatedAt,
    this.numberOfReviewers,
  });

  factory DriverId.fromJson(Map<String, dynamic> json) => DriverId(
        id: json['_id'] as String?,
        userId: json['userId'] as String?,
        driverInfoId: json['driverInfoId'] as String?,
        categoryId: json['categoryId'] as String?,
        carModel: json['carModel'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        isActive: json['isActive'] as bool?,
        profit: json['profit'] as int?,
        trips: json['trips'] as int?,
        countryCode: json['countryCode'] as dynamic,
        location: json['location'] as String?,
        phone: json['phone'] as String?,
        rating: (json['rating'] as num?)?.toDouble(),
        isApproved: json['isApproved'] as bool?,
        adminIgnore: json['adminIgnore'] as bool?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        numberOfReviewers: json['numberOfReviewers'] as int?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userId': userId,
        'driverInfoId': driverInfoId,
        'categoryId': categoryId,
        'carModel': carModel,
        'firstName': firstName,
        'lastName': lastName,
        'isActive': isActive,
        'profit': profit,
        'trips': trips,
        'countryCode': countryCode,
        'location': location,
        'phone': phone,
        'rating': rating,
        'isApproved': isApproved,
        'adminIgnore': adminIgnore,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'numberOfReviewers': numberOfReviewers,
      };
}
