import 'package:fourtyninehub/features/RideRequest/domain/entity/car_type_entity.dart';

class CarTypeModel extends CarTypeEntity {
  CarTypeModel(
      {required super.sId,
      required super.brand,
      required super.model,
      required super.year,
      required super.type,
      required super.subCategory,
      required super.mainCategory,
      required super.createdAt,
      required super.updatedAt});

  factory CarTypeModel.fromJson(Map<String, dynamic> json) {
    return CarTypeModel(
      sId: json['_id'],
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      type: json['type'],
      subCategory: json['sub_category'],
      mainCategory: json['main_category'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['brand'] = brand;
    data['model'] = model;
    data['year'] = year;
    data['type'] = type;
    data['sub_category'] = subCategory;
    data['main_category'] = mainCategory;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
