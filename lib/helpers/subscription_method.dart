import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class SubscriptionMethod {
  subscribe({
    required String subscribeId,
    required String title,
    bool? showRegular,
  }) {
    serviceLocator<SubscriptionController>().showSubscriptionPlans(
      showRegular: showRegular,
      wallets: [
        WalletTypes.mainWallet,
      ],
      subCategoryId: subscribeId,
      title: title,
    );
  }
}
