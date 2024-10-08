import '../../domain/entity/value_entity_p.dart';

class ValueModel extends ValueEntity {
  ValueModel({
    required super.ar,
    required super.en,
  });

  factory ValueModel.fromJson(Map<String, dynamic> json){
    return ValueModel(
      ar:json['ar'] ?? '',
      en: json['en']?? '',
    );
  }
}
