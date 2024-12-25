class DriverInfoModel {
  int? deadlineId;
  int? deadlineLicense;
  int? deadLineDriverLicense;
  int? tripCount;
  int? profit;
  int? totalRating;
  bool? freeRide;
  String? workingType;
  String? deadlineSubscription;
  DriverInfoModel({
    this.deadlineId,
    this.deadlineLicense,
    this.deadLineDriverLicense,
    this.tripCount,
    this.profit,
    this.totalRating,
    this.deadlineSubscription,
    this.freeRide,
    this.workingType,
  });

  factory DriverInfoModel.fromJson(Map<String, dynamic> json) {
    return DriverInfoModel(
      deadlineId: json['deadlineId'] as int?,
      deadlineLicense: json['deadlineLicense'] as int?,
      deadLineDriverLicense: json['deadLineDriverLicense'] as int?,
      tripCount: json['tripCount'] as int?,
      profit: json['profit'] as int?,
      totalRating: json['totalRating'] as int?,
      deadlineSubscription: json['deadlineSubscription'] as String?,
      freeRide: json['freeRide'] as bool?,
      workingType: json['workingType'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'deadlineId': deadlineId,
        'deadlineLicense': deadlineLicense,
        'deadLineDriverLicense': deadLineDriverLicense,
        'tripCount': tripCount,
        'profit': profit,
        'totalRating': totalRating,
        'freeRide': freeRide,
        'workingType': workingType,
      };
}
