import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';

class GovernorateModel extends GovernorateEntity {
  GovernorateModel({required super.id, required super.nameAr, required super.nameEn});

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    return GovernorateModel(id: json['_id'], nameAr: json['governorate_name_ar'], nameEn: json['governorate_name_en']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['governorate_name_ar'] = nameAr;
    data['governorate_name_en'] = nameEn;
    return data;
  }
}
