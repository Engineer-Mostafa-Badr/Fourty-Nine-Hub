import '../../domain/entities/subscribtion_plans_entity.dart';

class SubscriptionPlansModel extends SubscribtionPlansEntity {
  SubscriptionPlansModel(
      {required super.regularPlans, required super.premiumPlans});
  factory SubscriptionPlansModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlansModel(
        regularPlans: json['regular'].cast<num>(),
        premiumPlans: json['regular'].cast<num>());
  }
}
