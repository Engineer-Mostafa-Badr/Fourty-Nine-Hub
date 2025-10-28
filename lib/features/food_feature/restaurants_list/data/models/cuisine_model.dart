import '../../domain/entities/cuisine_entity.dart';

class CuisineModel extends CuisineEntity {
  CuisineModel({required super.id, required super.name});

  factory CuisineModel.fromJson(Map<String, dynamic> json) {
    return CuisineModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
