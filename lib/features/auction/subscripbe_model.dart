import 'package:fourtyninehub/features/auction/subscripbe_entity.dart';

class SubscriptionModel extends SubscriptionEntity {
  SubscriptionModel({
    bool? endPointSubscription,
    bool? userSubscription,
    String? subCategoryId,
    List<String>? paymentMethod,
  }) : super(
    endPointSubscription: endPointSubscription,
    userSubscription: userSubscription,
    subCategoryId: subCategoryId,
    paymentMethod: paymentMethod,
  );

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
