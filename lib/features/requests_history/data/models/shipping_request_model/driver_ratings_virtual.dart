import 'rate.dart';

class DriverRatingsVirtual {
  String? id;
  String? driverId;
  String? categoryId;
  String? userId;
  String? loadingTripId;
  Rate? rate;
  String? comment;
  double? subTotalRating;
  DateTime? createdAt;
  DateTime? updatedAt;

  DriverRatingsVirtual({
    this.id,
    this.driverId,
    this.categoryId,
    this.userId,
    this.loadingTripId,
    this.rate,
    this.comment,
    this.subTotalRating,
    this.createdAt,
    this.updatedAt,
  });

  factory DriverRatingsVirtual.fromJson(Map<String, dynamic> json) {
    return DriverRatingsVirtual(
      id: json['_id'] as String?,
      driverId: json['driverId'] as String?,
      categoryId: json['categoryId'] as String?,
      userId: json['userId'] as String?,
      loadingTripId: json['loadingTripId'] as String?,
      rate: json['rate'] == null
          ? null
          : Rate.fromJson(json['rate'] as Map<String, dynamic>),
      comment: json['comment'] as String?,
      subTotalRating: (json['subTotalRating'] as num?)?.toDouble(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'driverId': driverId,
        'categoryId': categoryId,
        'userId': userId,
        'loadingTripId': loadingTripId,
        'rate': rate?.toJson(),
        'comment': comment,
        'subTotalRating': subTotalRating,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
