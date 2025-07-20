enum SubscriptionStatus { notSubscribed, regular, premium }

extension SubscriptionStatusExtension on SubscriptionStatus {
  String get status {
    switch (this) {
      case SubscriptionStatus.notSubscribed:
        return 'not subscribed';
      case SubscriptionStatus.regular:
        return 'regular';
      case SubscriptionStatus.premium:
        return 'premium';
    }
  }
}