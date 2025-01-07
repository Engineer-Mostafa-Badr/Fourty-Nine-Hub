class RiderInfoId {
  String? id;
  dynamic idFrontKey;
  dynamic idBehindKey;
  dynamic idExpiryDate;
  String? idNumber;
  dynamic drivingLicenseFrontKey;
  dynamic drivingLicenseBehindKey;
  dynamic drivingLicenseExpiryDate;
  String? confirmIdentityKey;
  dynamic carLicenseFrontKey;
  dynamic carLicenseBehindKey;
  dynamic carLicenseExpiryDate;
  dynamic criminalRecordExpiryDate;
  dynamic technicalExaminationExpiryDate;
  dynamic drugAnalysisExpiryDate;
  List<dynamic>? carPicturesKey;
  dynamic carPlateLetters;
  dynamic carPlateNumbers;
  bool? smoker;
  bool? airConditioner;
  String? plateInfo;
  bool? isApproved;
  bool? isRejected;
  bool? comfort;
  String? driverLicenseNumber;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? driverId;

  RiderInfoId({
    this.id,
    this.idFrontKey,
    this.idBehindKey,
    this.idExpiryDate,
    this.idNumber,
    this.drivingLicenseFrontKey,
    this.drivingLicenseBehindKey,
    this.drivingLicenseExpiryDate,
    this.confirmIdentityKey,
    this.carLicenseFrontKey,
    this.carLicenseBehindKey,
    this.carLicenseExpiryDate,
    this.criminalRecordExpiryDate,
    this.technicalExaminationExpiryDate,
    this.drugAnalysisExpiryDate,
    this.carPicturesKey,
    this.carPlateLetters,
    this.carPlateNumbers,
    this.smoker,
    this.airConditioner,
    this.plateInfo,
    this.isApproved,
    this.isRejected,
    this.comfort,
    this.driverLicenseNumber,
    this.createdAt,
    this.updatedAt,
    this.driverId,
  });

  factory RiderInfoId.fromJson(Map<String, dynamic> json) => RiderInfoId(
        id: json['_id'] as String?,
        idFrontKey: json['idFrontKey'] as dynamic,
        idBehindKey: json['idBehindKey'] as dynamic,
        idExpiryDate: json['idExpiryDate'] as dynamic,
        idNumber: json['idNumber'] as String?,
        drivingLicenseFrontKey: json['drivingLicenseFrontKey'] as dynamic,
        drivingLicenseBehindKey: json['drivingLicenseBehindKey'] as dynamic,
        drivingLicenseExpiryDate: json['drivingLicenseExpiryDate'] as dynamic,
        confirmIdentityKey: json['confirmIdentityKey'] as String?,
        carLicenseFrontKey: json['carLicenseFrontKey'] as dynamic,
        carLicenseBehindKey: json['carLicenseBehindKey'] as dynamic,
        carLicenseExpiryDate: json['carLicenseExpiryDate'] as dynamic,
        criminalRecordExpiryDate: json['criminalRecordExpiryDate'] as dynamic,
        technicalExaminationExpiryDate:
            json['technicalExaminationExpiryDate'] as dynamic,
        drugAnalysisExpiryDate: json['drugAnalysisExpiryDate'] as dynamic,
        carPicturesKey: json['carPicturesKey'] as List<dynamic>?,
        carPlateLetters: json['carPlateLetters'] as dynamic,
        carPlateNumbers: json['carPlateNumbers'] as dynamic,
        smoker: json['smoker'] as bool?,
        airConditioner: json['airConditioner'] as bool?,
        plateInfo: json['plateInfo'] as String?,
        isApproved: json['isApproved'] as bool?,
        isRejected: json['isRejected'] as bool?,
        comfort: json['comfort'] as bool?,
        driverLicenseNumber: json['driverLicenseNumber'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        driverId: json['driverId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'idFrontKey': idFrontKey,
        'idBehindKey': idBehindKey,
        'idExpiryDate': idExpiryDate,
        'idNumber': idNumber,
        'drivingLicenseFrontKey': drivingLicenseFrontKey,
        'drivingLicenseBehindKey': drivingLicenseBehindKey,
        'drivingLicenseExpiryDate': drivingLicenseExpiryDate,
        'confirmIdentityKey': confirmIdentityKey,
        'carLicenseFrontKey': carLicenseFrontKey,
        'carLicenseBehindKey': carLicenseBehindKey,
        'carLicenseExpiryDate': carLicenseExpiryDate,
        'criminalRecordExpiryDate': criminalRecordExpiryDate,
        'technicalExaminationExpiryDate': technicalExaminationExpiryDate,
        'drugAnalysisExpiryDate': drugAnalysisExpiryDate,
        'carPicturesKey': carPicturesKey,
        'carPlateLetters': carPlateLetters,
        'carPlateNumbers': carPlateNumbers,
        'smoker': smoker,
        'airConditioner': airConditioner,
        'plateInfo': plateInfo,
        'isApproved': isApproved,
        'isRejected': isRejected,
        'comfort': comfort,
        'driverLicenseNumber': driverLicenseNumber,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'driverId': driverId,
      };
}
