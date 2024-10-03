class DriverStatisticeModel {
  int? deadlineSubscription;
  int? deadlineId;
  int? deadlineLicense;
  int? deadLineDriverLicense;
  int? tripCount;
  int? profit;
  double? totalRating;

  DriverStatisticeModel({
    this.deadlineSubscription,
    this.deadlineId,
    this.deadlineLicense,
    this.deadLineDriverLicense,
    this.tripCount,
    this.profit,
    this.totalRating,
  });

  factory DriverStatisticeModel.fromJson(Map<String, dynamic> json) {
    return DriverStatisticeModel(
      deadlineSubscription: json['deadlineSubscription'] as int?,
      deadlineId: json['deadlineId'] as int?,
      deadlineLicense: json['deadlineLicense'] as int?,
      deadLineDriverLicense: json['deadLineDriverLicense'] as int?,
      tripCount: json['tripCount'] as int?,
      profit: json['profit'] as int?,
      totalRating: (json['totalRating'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'deadlineSubscription': deadlineSubscription,
        'deadlineId': deadlineId,
        'deadlineLicense': deadlineLicense,
        'deadLineDriverLicense': deadLineDriverLicense,
        'tripCount': tripCount,
        'profit': profit,
        'totalRating': totalRating,
      };
}
