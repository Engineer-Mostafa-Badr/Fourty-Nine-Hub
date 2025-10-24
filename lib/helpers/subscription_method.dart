import '../core/enums/wallet_types_enums.dart';
import '../features/subscripe/presentation/controllers/subscription_controller.dart';
import '../service_locator/service_locator.dart';

class SubscriptionMethod {
  subscribe({
    required String subscribeId,
    required String title,
    bool? showRegular,
    final Function(bool success)? onSubscribe,
  }) {
    serviceLocator<SubscriptionController>().showSubscriptionPlans(
      showRegular: showRegular,
      onSubscribe: onSubscribe,
      wallets: [
        WalletTypes.mainWallet,
      ],
      subCategoryId: subscribeId,
      title: title,
    );
  }
}
