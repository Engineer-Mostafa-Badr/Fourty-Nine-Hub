class DriverInfoId {
  dynamic idNumber;
  String? id;
  String? idFrontKey;
  String? idBehindKey;
  DateTime? idExpiryDate;
  String? drivingLicenseFrontKey;
  String? drivingLicenseBehindKey;
  DateTime? drivingLicenseExpiryDate;
  String? carLicenseFrontKey;
  String? carLicenseBehindKey;
  DateTime? carLicenseExpiryDate;
  String? carPicturesKey;
  bool? isApproved;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? driverId;
  String? carPlateInformation;

  DriverInfoId({
    this.idNumber,
    this.id,
    this.idFrontKey,
    this.idBehindKey,
    this.idExpiryDate,
    this.drivingLicenseFrontKey,
    this.drivingLicenseBehindKey,
    this.drivingLicenseExpiryDate,
    this.carLicenseFrontKey,
    this.carLicenseBehindKey,
    this.carLicenseExpiryDate,
    this.carPicturesKey,
    this.isApproved,
    this.createdAt,
    this.updatedAt,
    this.driverId,
    this.carPlateInformation,
  });

  factory DriverInfoId.fromJson(Map<String, dynamic> json) => DriverInfoId(
        idNumber: json['idNumber'] as dynamic,
        id: json['_id'] as String?,
        idFrontKey: json['idFrontKey'] as String?,
        idBehindKey: json['idBehindKey'] as String?,
        idExpiryDate: json['idExpiryDate'] == null
            ? null
            : DateTime.parse(json['idExpiryDate'] as String),
        drivingLicenseFrontKey: json['drivingLicenseFrontKey'] as String?,
        drivingLicenseBehindKey: json['drivingLicenseBehindKey'] as String?,
        drivingLicenseExpiryDate: json['drivingLicenseExpiryDate'] == null
            ? null
            : DateTime.parse(json['drivingLicenseExpiryDate'] as String),
        carLicenseFrontKey: json['carLicenseFrontKey'] as String?,
        carLicenseBehindKey: json['carLicenseBehindKey'] as String?,
        carLicenseExpiryDate: json['carLicenseExpiryDate'] == null
            ? null
            : DateTime.parse(json['carLicenseExpiryDate'] as String),
        carPicturesKey: json['carPicturesKey'] as String?,
        isApproved: json['isApproved'] as bool?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        driverId: json['driverId'] as String?,
        carPlateInformation: json['carPlateInformation'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'idNumber': idNumber,
        '_id': id,
        'idFrontKey': idFrontKey,
        'idBehindKey': idBehindKey,
        'idExpiryDate': idExpiryDate?.toIso8601String(),
        'drivingLicenseFrontKey': drivingLicenseFrontKey,
        'drivingLicenseBehindKey': drivingLicenseBehindKey,
        'drivingLicenseExpiryDate': drivingLicenseExpiryDate?.toIso8601String(),
        'carLicenseFrontKey': carLicenseFrontKey,
        'carLicenseBehindKey': carLicenseBehindKey,
        'carLicenseExpiryDate': carLicenseExpiryDate?.toIso8601String(),
        'carPicturesKey': carPicturesKey,
        'isApproved': isApproved,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'driverId': driverId,
        'carPlateInformation': carPlateInformation,
      };
}
