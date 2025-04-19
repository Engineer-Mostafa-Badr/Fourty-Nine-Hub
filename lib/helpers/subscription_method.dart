import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class SubscriptionMethod {
  subscribe({
    required String subscribeId,
    required String title,
    bool? showRegular,
    final Function? onSubscribe,
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
