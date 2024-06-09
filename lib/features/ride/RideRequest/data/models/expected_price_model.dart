import '../../domain/entity/Expected_price_entity.dart';

class ExpectedPriceModel extends ExpectedPriceEntity {
  ExpectedPriceModel(
      {super.status = true,
      required super.price,
      required super.distance,
      required super.duration});

  factory ExpectedPriceModel.fromJson(Map<String, dynamic> json) {
    return ExpectedPriceModel(
        status: json['status'] ?? true,
        price: json['price'] ?? 80,
        distance: json['distance'],
        duration: json['time']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['price'] = price;
    data['distance'] = distance;
    data['duration'] = duration;
    return data;
  }
}
