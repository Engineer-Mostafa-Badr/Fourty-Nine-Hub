class InstallmentPlanEntity {
  final num duration;
  final num installment;
  final num startPrice;
  final String? adId;
  final String name;
  InstallmentPlanEntity({
    required this.duration,
    required this.installment,
    required this.startPrice,
    required this.name,
    this.adId,
  });
}
