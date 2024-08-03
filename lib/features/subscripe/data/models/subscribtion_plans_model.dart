import '../../domain/entities/subscription_plans_entity.dart';

class SubscriptionPlansModel extends SubscriptionPlansEntity {
  SubscriptionPlansModel(
      {required super.regularPlans, required super.premiumPlans});
  factory SubscriptionPlansModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlansModel(
        regularPlans: json['regular'].cast<num>(),
        premiumPlans: json['premium'].cast<num>());
  }
}
