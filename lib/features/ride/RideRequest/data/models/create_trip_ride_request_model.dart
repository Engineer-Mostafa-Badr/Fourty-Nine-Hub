class CreateTripRideRequestModel {
  String? categoryId;
  String? fromTitle;
  String? toTitle;
  double? price;
  int? passangers;
  String? phone;
  String? time;
  String? desc;

  CreateTripRideRequestModel({
    this.categoryId,
    this.fromTitle,
    this.toTitle,
    this.price,
    this.passangers,
    this.phone,
    this.time,
    this.desc,
  });

  factory CreateTripRideRequestModel.fromJson(Map<String, dynamic> json) {
    return CreateTripRideRequestModel(
      categoryId: json['categoryId'] as String?,
      fromTitle: json['fromTitle'] as String?,
      toTitle: json['toTitle'] as String?,
      price: json['price'] as double?,
      passangers: json['passangers'] as int?,
      phone: json['phone'] as String?,
      time: json['time'] as String?,
      desc: json['desc'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'fromTitle': fromTitle,
        'toTitle': toTitle,
        'price': price,
        'passangers': passangers,
        'phone': phone,
        'time': time,
        'desc': desc,
      };
}
