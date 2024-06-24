import '../../domain/entities/installment_plan_entity.dart';

class InstallmentPlanModel extends InstallmentPlanEntity {
  InstallmentPlanModel({required super.duration, required super.installment});
  factory InstallmentPlanModel.fromJson(Map<String, dynamic> json) {
    return InstallmentPlanModel(
      duration: json['duration'],
      installment: json['installment']
    );
  }
}
