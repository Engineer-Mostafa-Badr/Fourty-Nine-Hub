// import '../../domain/entity/Expected_price_entity.dart';

// class ExpectedPriceModel extends ExpectedPriceEntity {
//   ExpectedPriceModel(
//       {super.status = true,
//       required super.price,
//       required super.distance,
//       required super.duration});

//   factory ExpectedPriceModel.fromJson(Map<String, dynamic> json) {
//     return ExpectedPriceModel(
//         status: json['status'] ?? true,
//         price: json['price'] ?? 80,
//         distance: json['distance'],
//         duration: json['duration'] ?? 0);
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['price'] = price;
//     data['distance'] = distance;
//     data['duration'] = duration;
//     return data;
//   }
// }

import 'package:fourtyninehub/features/ride/RideRequest/domain/entity/expected_price_entity.dart';

class ExpectedPriceModel extends ExpectedPriceEntity {
  ExpectedPriceModel({
    bool status = true,
    required double price,
    required double distance,
    required double duration,
  }) : super(
          status: status,
          price: price,
          distance: distance,
          duration: duration,
        );

  factory ExpectedPriceModel.fromJson(Map<String, dynamic> json) {
    return ExpectedPriceModel(
      status: json['status'] ?? true,
      price: json['price'] ?? 80.0,
      distance: json['distance']?.toDouble() ?? 0.0,
      duration: json['duration']?.toDouble() ?? 0.0,
    );
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
