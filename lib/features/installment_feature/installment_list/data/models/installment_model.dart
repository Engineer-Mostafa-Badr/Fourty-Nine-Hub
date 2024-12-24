import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';

import '../../domain/entities/installment_entity.dart';

class InstallmentModel extends InstallmentEntity {
  InstallmentModel(
      {required super.id
      // , super.plans
      ,
      required super.ad});
  factory InstallmentModel.fromJson(Map<String, dynamic> json) {
    return InstallmentModel(
      id: json['_id'],
      // plans: json['plans'] == null
      //     ? null
      //     : (json['plans'] as List)
      //         .map((e) => InstallmentPlanModel.fromJson(e))
      //         .toList(),
      ad: json['ads'] != null ? AdModel.fromJson(json['ads']) : null,
    );
  }
}
