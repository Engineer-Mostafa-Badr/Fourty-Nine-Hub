class SubscriptionEntity {
  final bool? endPointSubscription;
  final bool? userSubscription;
  final String? subCategoryId;
  final List<String>? paymentMethod;

  SubscriptionEntity({
    this.endPointSubscription,
    this.userSubscription,
    this.subCategoryId,
    this.paymentMethod,
  });
}
