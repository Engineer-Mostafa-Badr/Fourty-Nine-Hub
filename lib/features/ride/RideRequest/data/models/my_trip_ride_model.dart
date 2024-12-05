class MyTripRideModel {
  String? id;
  String? userId;
  dynamic driverId;
  String? categoryId;
  String? fromTitle;
  String? toTitle;
  int? profit;
  bool? isPremium;
  int? price;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  MyTripRideModel({
    this.id,
    this.userId,
    this.driverId,
    this.categoryId,
    this.fromTitle,
    this.toTitle,
    this.profit,
    this.isPremium,
    this.price,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory MyTripRideModel.fromJson(Map<String, dynamic> json) {
    return MyTripRideModel(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      driverId: json['driverId'] as dynamic,
      categoryId: json['categoryId'] as String?,
      fromTitle: json['fromTitle'] as String?,
      toTitle: json['toTitle'] as String?,
      profit: json['profit'] as int?,
      isPremium: json['isPremium'] as bool?,
      price: json['price'] as int?,
      status: json['status'] as String?,
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
        'userId': userId,
        'driverId': driverId,
        'categoryId': categoryId,
        'fromTitle': fromTitle,
        'toTitle': toTitle,
        'profit': profit,
        'isPremium': isPremium,
        'price': price,
        'status': status,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
