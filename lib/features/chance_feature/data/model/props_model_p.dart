import '../../domain/entity/Props_Entity_p.dart';

class PropsModel extends PropsEntity {
  PropsModel({
    required super.propertyId,
    required super.value,
  });

  factory PropsModel.fromJson(Map<String, dynamic> json) {
    return PropsModel(
      propertyId: json['propertyId'] ?? "" ,
      value: json['value'] ?? [] ,
    );
  }
}
