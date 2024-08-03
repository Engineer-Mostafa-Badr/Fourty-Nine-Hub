import 'package:fourtyninehub/res/strings/labels.dart';

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

  String get translatedName{
    switch (this) {
      case WalletTypes.mainWallet:
        return Labels.mainWallet;
      case WalletTypes.giftWallet:
        return Labels.giftWallet;
      case WalletTypes.balance:
        return Labels.balance;
    }
  }
}

extension WalletTypesXString on String {
  WalletTypes get toWalletType {
    switch (toLowerCase()) {
      case 'mainWallet':
        return WalletTypes.mainWallet;
      case 'giftWallet':
        return WalletTypes.giftWallet;
      case 'balance':
        return WalletTypes.balance;
      default:
        return WalletTypes.mainWallet;
    }
  }
}
