import '../../../../ads_feature/ads/domain/entities/ad_entity.dart';

class InstallmentEntity {
  final String id;
  // final List<InstallmentPlanEntity>? plans;
  final AdEntity? ad;
  InstallmentEntity({
    required this.id,
    // this.plans,
    this.ad,
  });
}
