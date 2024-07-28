import '../../domain/entities/installment_plan_entity.dart';

class InstallmentPlanModel extends InstallmentPlanEntity {
  InstallmentPlanModel(
      {required super.duration,
      super.adId,
      required super.installment,
      required super.startPrice,
      required super.name});
  factory InstallmentPlanModel.fromJson(Map<String, dynamic> json) {
    return InstallmentPlanModel(
      duration: json['duration'],
      installment: num.parse('${json['installment']}'),
      startPrice: json['start_price'] ?? 0,
      name: json['name'] ?? '',
    );
  }
  Map<String, dynamic> toJson() => {
        "name": name,
        "start_price": startPrice,
        "number_months": duration,
        "financial_payment": installment
      };
}
