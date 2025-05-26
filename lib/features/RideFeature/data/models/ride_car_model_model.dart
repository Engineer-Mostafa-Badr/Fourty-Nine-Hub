import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_brand_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/ride_model_entity.dart';

class RideCarModelModel extends RideModelEntity {
  RideCarModelModel({required super.id, required super.modelAr, required super.modelEn});
  
  factory RideCarModelModel.fromJson(Map<String, dynamic> json) {
    return RideCarModelModel(
        id: json['_id'] ?? '',
        modelAr: json['modelAr'] ?? '',
        modelEn: json['modelEn'] ?? '');
  }
}