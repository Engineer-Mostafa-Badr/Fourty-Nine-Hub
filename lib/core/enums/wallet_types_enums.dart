enum WalletTypes { mainWallet, giftWallet, balance }

extension WalletTypesX on WalletTypes {
  String value() {
    switch (this) {
      case WalletTypes.mainWallet:
        return 'mainWallet';
      case WalletTypes.giftWallet:
        return 'giftWallet';
      case WalletTypes.balance:
        return 'balance';
    }
  }
}
