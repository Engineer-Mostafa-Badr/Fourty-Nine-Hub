
import '../../domain/entities/option_entity.dart';

class OptionModel extends OptionEntity {
  OptionModel({required super.id, required super.name, required super.price});
  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
    );
  }
}
