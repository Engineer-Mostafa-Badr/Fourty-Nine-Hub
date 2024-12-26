import 'package:fourtyninehub/features/social_media/snap/domain/entity/filter_entity.dart';

class FilterModel extends FilterEntity {
  FilterModel(
      {required super.name, required super.deepar, required super.image});

  factory FilterModel.fromJson(Map<String, dynamic> json) {
    return FilterModel(
        name: json['name'] ?? '',
        deepar: json['deepar'] ?? '',
        image: json['image'] ?? '');
  }
}
