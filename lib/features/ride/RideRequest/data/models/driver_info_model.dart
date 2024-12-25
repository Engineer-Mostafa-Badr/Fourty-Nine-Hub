class DriverInfoModel {
  int? deadlineId;
  int? deadlineLicense;
  int? deadLineDriverLicense;
  int? tripCount;
  int? profit;
  int? totalRating;
  bool? freeRide;
  String? workingType;
  int? deadlineSubscriptionRegular;
  int? deadlineSubscriptionPremium;
  DriverInfoModel({
    this.deadlineId,
    this.deadlineLicense,
    this.deadLineDriverLicense,
    this.tripCount,
    this.profit,
    this.totalRating,
    this.deadlineSubscriptionRegular,
    this.deadlineSubscriptionPremium,
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
      deadlineSubscriptionRegular: json['deadlineSubscriptionRegular'] as int?,
      deadlineSubscriptionPremium: json['deadlineSubscriptionPremium'] as int?,
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
