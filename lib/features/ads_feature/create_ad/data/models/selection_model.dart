import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/selection_entity.dart';

class SelectionModel extends SelectionEntity {
  SelectionModel({required super.nameAr, required super.nameEn, super.type});
  factory SelectionModel.fromJson(Map<String, dynamic> json) {
    return SelectionModel(
      nameAr: json['ar'].toString(),
      nameEn: json['en'].toString(),
      type: json['type']??'',
    );
  }
}
