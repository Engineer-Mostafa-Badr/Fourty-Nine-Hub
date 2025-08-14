import '../../../../../common/functions/helper/lang_helper.dart';
import '../../domain/entities/master_entity.dart';

class MasterModel extends MasterEntity {
  MasterModel({required super.id, required super.name});
  factory MasterModel.fromJson(Map<String, dynamic> json) {
    return MasterModel(
        id: json['_id'],
        name: getLang() == 'ar' ? json['name_ar'] : json['name_en']);
  }
}
