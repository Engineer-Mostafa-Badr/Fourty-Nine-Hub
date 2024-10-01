class TripInfo {
  int? distance;
  int? duration;
  int? price;
  String? paymentMethod;

  TripInfo({this.distance, this.duration, this.price, this.paymentMethod});

  factory TripInfo.fromJson(Map<String, dynamic> json) => TripInfo(
        distance: json['distance'] as int?,
        duration: json['duration'] as int?,
        price: json['price'] as int?,
        paymentMethod: json['paymentMethod'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'distance': distance,
        'duration': duration,
        'price': price,
        'paymentMethod': paymentMethod,
      };
}
