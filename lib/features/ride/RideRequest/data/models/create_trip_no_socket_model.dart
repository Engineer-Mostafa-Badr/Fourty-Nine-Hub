class CreateTripNoSocketModel {
  String? categoryId;
  String? fromTitle;
  String? toTitle;
  int? price;
  String? phone;
  String? time;
  String? desc;
  int? passangers;
  bool? isPremium;
  CreateTripNoSocketModel({
    this.categoryId,
    this.fromTitle,
    this.toTitle,
    this.price,
    this.phone,
    this.time,
    this.desc,
    this.passangers,
    this.isPremium,
  });

  factory CreateTripNoSocketModel.fromJson(Map<String, dynamic> json) {
    return CreateTripNoSocketModel(
      passangers: json['passangers'],
      isPremium: json['isPremium'],
      categoryId: json['categoryId'] as String?,
      fromTitle: json['fromTitle'] as String?,
      toTitle: json['toTitle'] as String?,
      price: json['price'] as int?,
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
        'phone': phone,
        'time': time,
        'desc': desc,
        'isPremium': isPremium,
        'passangers': passangers,
      };
  // createTrip(){

  // }
  // createPremium(){
  //   return
  // }
}
