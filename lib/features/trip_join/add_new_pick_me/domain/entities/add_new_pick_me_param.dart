class AddNewPickMeParam {
  String? categoryId;
  String? fromAr;
  String? toAr;
  String? fromEn;
  String? toEn;
  num? distance;
  num? duration;
  num? price;
  num? passengers;
  String? phone;
  num? time;
  bool? isRepeat;

  AddNewPickMeParam({
    this.categoryId,
    this.fromAr,
    this.toAr,
    this.fromEn,
    this.toEn,
    this.distance,
    this.duration,
    this.price,
    this.passengers,
    this.phone,
    this.time,
    this.isRepeat,
  });

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'fromAr': fromAr,
      'toAr': toAr,
      'fromEn': fromEn,
      'toEn': toEn,
      'distance': distance,
      'duration': duration,
      'price': price,
      'passengers': passengers,
      'phone': phone,
      'time': time,
      'isRepeat': isRepeat,
    };
  }
}
