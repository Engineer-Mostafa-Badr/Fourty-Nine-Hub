import 'package:fourtyninehub/features/azkaar/domain/entity/azkar_details_entity.dart';

class AzkarDetailsModel extends AzkarDetailsEntity {
  AzkarDetailsModel(
      {required super.id,
      required super.category,
      required super.zekr,
      required super.description,
      required super.count,
      required super.reference,
      required super.search});

  factory AzkarDetailsModel.fromJson(Map<String, dynamic> json) {
    return AzkarDetailsModel(
      id: json['_id'] ??'',
      category: json['category'] ??'',
      zekr: json['zekr'] ??'',
      description: json['description'] ??'',
      count: json['count']  ??0,
      reference: json['reference']  ??'',
      search: json['search']  ??'',
    );
  }
}
