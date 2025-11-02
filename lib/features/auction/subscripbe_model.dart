import 'package:fourtyninehub/features/auction/subscripbe_entity.dart';

class SubscriptionModel extends SubscriptionEntity {
  SubscriptionModel({
    super.endPointSubscription,
    super.userSubscription,
    super.subCategoryId,
    super.paymentMethod,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      endPointSubscription: json['endPointSubscription'] as bool?,
      userSubscription: json['userSubscription'] as bool?,
      subCategoryId: json['subCategoryId'] as String?,
      paymentMethod: (json['paymentMethod'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }
}
