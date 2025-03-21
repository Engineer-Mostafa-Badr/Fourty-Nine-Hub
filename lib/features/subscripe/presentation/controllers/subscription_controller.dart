import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/subscripe/domain/usecases/get_active_subscription_amounts.dart';
import 'package:fourtyninehub/features/subscripe/presentation/widgets/amounts.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/routes/pages.dart';

import '../../domain/usecases/check_if_user_subscribed_usecase.dart';
import '../../domain/usecases/get_subscription_plans_usecase.dart';
import '../../domain/usecases/subscribe_usecase.dart';
import '../widgets/subscription_plans.dart';

class SubscriptionController {
  //to pass current context
  final BuildContext context =
      AppPages.router.configuration.navigatorKey.currentContext!;
  final CheckIfUserSubscribedUseCase _checkIfUserSubscribedUseCase;
  final GetSubscriptionPlansUseCase _getSubscriptionPlansUseCase;
  final SubscribeUseCase _subscribeUseCase;
  final GetActiveSubscriptionAmountsUseCase
      _getActiveSubscriptionAmountsUseCase;

  SubscriptionController(
      this._checkIfUserSubscribedUseCase,
      this._getSubscriptionPlansUseCase,
      this._subscribeUseCase,
      this._getActiveSubscriptionAmountsUseCase);

  void checkIfUserSubscribed(
      {required Function onSubscribed,
      required String subCategoryId,
      String? title,
      showRegular}) async {
    showLoadingDialog(context);
    final response = await _checkIfUserSubscribedUseCase(subCategoryId);
    AppPages.router.pop();
    response.fold(
        (l) => showErrorMessage(
              context,
              Labels.errorHappened,
            ), (data) async {
      if (data) {
        onSubscribed();
      } else {
        showSubscriptionPlans(
            subCategoryId: subCategoryId,
            title: title,
            showRegular: showRegular);
      }
    });
  }

  bool _isBottomSheetShown = false;

  Future<void> showSubscriptionPlans(
      {List<WalletTypes>? wallets,
      required String subCategoryId,
      String? title,
      bool? showRegular}) async {
    if (!_isBottomSheetShown) {
      _isBottomSheetShown = true;

      // Example wallets data or pass in your actual wallet list
      //List<WalletTypes> wallets = [];

      showLoadingDialog(context);

      final plansResponse = await _getSubscriptionPlansUseCase(subCategoryId);
      Navigator.of(context).pop(); // Close loading dialog

      plansResponse.fold((l) {
        showErrorMessage(context, Labels.errorHappened);
        _isBottomSheetShown = false; // Reset flag on error
      }, (plans) {
        bottomSheet(
          context: context,
          backColor: Theme.of(context).scaffoldBackgroundColor,
          isScrollControlled: true,
          widget: SubscriptionPlansWidget(
            showRegular: showRegular ?? true,
            title: title,
            subscribePlans: plans,
            subCategoryId: subCategoryId,
            paymentMenthods: wallets ??
                [
                  WalletTypes.mainWallet,
                ],
          ),
        );
      });

      _isBottomSheetShown = false; // Reset flag after bottom sheet is shown
    }
  }

  Future<void> showActiveSubscriptionAmounts(
      {required WalletTypes walletType}) async {
    final response =
        await _getActiveSubscriptionAmountsUseCase(const NoParams());
    response.fold(
      (l) => showErrorMessage(
        context,
        Labels.errorHappened,
      ),
      (data) => bottomSheet(
        context: context,
        widget: SubscriptoinAmountsWidget(
          amounts: data,
          walletType: walletType,
        ),
      ),
    );
  }

  //payment method

  Future<void> subscribe({required SubscribeParams subscribeParams}) async {
    final response = await _subscribeUseCase(subscribeParams);
    response.fold((l) {
      if (l is ServerFailure) {
        if (l.statusCode == 400 &&
            subscribeParams.walletType != WalletTypes.giftWallet &&
            subscribeParams.walletType != WalletTypes.balance) {
          showActiveSubscriptionAmounts(walletType: subscribeParams.walletType);
        } else if (l.statusCode == 400 &&
            subscribeParams.walletType == WalletTypes.giftWallet) {
          AppPages.router.pop();
          showErrorMessage(
              context, "You don't have enough balance at Gift Wallet");
        } else if (l.statusCode == 400 &&
            subscribeParams.walletType == WalletTypes.balance) {
          AppPages.router.pop();
          showErrorMessage(
              context, "You don't have enough balance at Balance Wallet");
        } else {
          AppPages.router.pop();

          showErrorMessage(context, l.message);
        }
      } else {
        showErrorMessage(context, Labels.errorHappened);
      }
    }, (data) {
      showSuccessMessage(context,
          context.isArabic ? "تم الاشتراك بنجاح" : "Subscribed successfully");
    });
  }
}
//9.16 8/9/2024
