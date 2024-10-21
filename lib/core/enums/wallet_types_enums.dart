import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
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

  String get translatedName {
    switch (this) {
      case WalletTypes.mainWallet:
        return LocaleKeys.wallet.tr();
      case WalletTypes.giftWallet:
        return LocaleKeys.gift.tr();
      case WalletTypes.balance:
        return LocaleKeys.balance.tr();
    }
  }
}

extension WalletTypesXString on String {
  WalletTypes get toWalletType {
    switch (toLowerCase()) {
      case 'mainwallet':
        return WalletTypes.mainWallet;
      case 'giftwallet':
        return WalletTypes.giftWallet;
      case 'balance':
        return WalletTypes.balance;
      default:
        return WalletTypes.mainWallet;
    }
  }
}
