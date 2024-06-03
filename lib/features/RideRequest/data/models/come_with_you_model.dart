import '../../domain/entity/come_with_you_entity.dart';

class ComeWithYouRequestModel extends ComeWithYouRequestEntity {
  ComeWithYouRequestModel(
      {required super.vehicleId,
      required super.categoryId,
      required super.startLocation,
      required super.targetLocation,
      required super.from,
      required super.to,
      required super.price,
      required super.phone,
      required super.time});

  // ComeWithYouRequestModel.fromJson(Map<String, dynamic> json) {
  //   vehicleId = json['vehicleId'];
  //   categoryId = json['categoryId'];
  //   startLocation = json['startLocation'].cast<String>();
  //   targetLocation = json['targetLocation'].cast<String>();
  //   from = json['from'];
  //   to = json['to'];
  //   passengers = json['passengers'];
  //   price = json['price'];
  //   phone = json['phone'];
  //   time = json['time'];
  //   isRepeat = json['isRepeat'];
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vehicleId'] = vehicleId;
    data['categoryId'] = categoryId;
    data['startLocation'] = startLocation;
    data['targetLocation'] = targetLocation;
    data['from'] = from;
    data['to'] = to;
    data['passengers'] = passengers;
    data['price'] = price;
    data['phone'] = phone;
    data['time'] = time;
    data['isRepeat'] = isRepeat;
    return data;
  }
}
