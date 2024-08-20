import '../../domain/entities/detail_entity.dart';

class DetailModel extends DetailEntiy {
  DetailModel(
      {required super.label, required super.value, required super.type});
  factory DetailModel.fromJson(Map<String, dynamic> json) {
    return DetailModel(
      label: json['label'],
      type: json['type'],
      value: json['value'],
    );
  }
}
