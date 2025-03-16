import 'package:fourtyninehub/features/RideFeature/domain/entities/cost_per_km_entity.dart';

class CostPerKmModel extends CostPerKmEntity{
  CostPerKmModel({required super.highCostPerKm, required super.lowCostPerKm});

  //from json
  factory CostPerKmModel.fromJson(Map<String, dynamic> json) {
    return CostPerKmModel(
      highCostPerKm: json['highCostPerKm'],
      lowCostPerKm: json['lowCostPerKm'],
    );
  }
}