import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/routing_helper.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/subscripe/domain/usecases/get_active_subscription_amounts.dart';
import 'package:fourtyninehub/features/subscripe/presentation/widgets/amounts.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:go_router/go_router.dart';

import '../../domain/usecases/check_if_user_subscribed_usecase.dart';
import '../../domain/usecases/get_subscription_plans_usecase.dart';
import '../../domain/usecases/subscribe_usecase.dart';
import '../widgets/subscription_plans.dart';

class SubscriptionController {
  //to pass current context
  final BuildContext context = AppPages.router.configuration.navigatorKey.currentContext!;
  final CheckIfUserSubscribedUseCase _checkIfUserSubscribedUseCase;
  final GetSubscriptionPlansUseCase _getSubscriptionPlansUseCase;
  final SubscribeUseCase _subscribeUseCase;
  final GetActiveSubscriptionAmountsUseCase _getActiveSubscriptionAmountsUseCase;

  SubscriptionController(this._checkIfUserSubscribedUseCase, this._getSubscriptionPlansUseCase, this._subscribeUseCase,
      this._getActiveSubscriptionAmountsUseCase);

  void checkIfUserSubscribed({
    required Function onSubscribed,
    required String subCategoryId,
    String? title,
  }) async {
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
        showSubscriptionPlans(subCategoryId: subCategoryId, title: title);
      }
    });
  }

  // Future<void> showSubscriptionPlans({List<WalletTypes>? wallets, required String subCategoryId, String? title}) async {
  //    showLoadingDialog(context);
  //    Navigator.of(context).pop();
  //   final plansResponse = await _getSubscriptionPlansUseCase(subCategoryId);
  //   // AppPages.router.pop();
  //   plansResponse.fold(
  //       (l) {
  //         showErrorMessage(
  //             context,
  //             Labels.errorHappened,
  //           );
  //       }, (plans) {
  //     bottomSheet(
  //         context: context,
  //         backColor: Theme.of(context).scaffoldBackgroundColor,
  //         widget: SubscriptionPlansWidget(
  //           title: title,
  //           subscribePlans: plans,
  //           subCategoryId: subCategoryId,
  //           paymentMenthods: wallets,
  //         ));
  //   });
  // }
  bool _isBottomSheetShown = false;

  Future<void> showSubscriptionPlans({List<WalletTypes>? wallets, required String subCategoryId, String? title}) async {
    if (!_isBottomSheetShown) {
      _isBottomSheetShown = true;

      // Example wallets data or pass in your actual wallet list
      List<WalletTypes> wallets = [];

      showLoadingDialog(context);
      Navigator.of(context).pop(); // Close loading dialog

      final plansResponse = await _getSubscriptionPlansUseCase(subCategoryId);
      plansResponse.fold(
              (l) {
            showErrorMessage(context, Labels.errorHappened);
            _isBottomSheetShown = false; // Reset flag on error
          },
              (plans) {
            bottomSheet(
              context: context,
              backColor: Theme.of(context).scaffoldBackgroundColor,
              widget: SubscriptionPlansWidget(
                title: title,
                subscribePlans: plans,
                subCategoryId: subCategoryId,
                paymentMenthods: wallets,
              ),
            );
          }
      );

      _isBottomSheetShown = false; // Reset flag after bottom sheet is shown
    }
  }


  Future<void> showActiveSubscriptionAmounts({required WalletTypes walletType}) async {
    final response = await _getActiveSubscriptionAmountsUseCase(const NoParams());
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
        if (l.statusCode == 400) {
          showActiveSubscriptionAmounts(walletType: subscribeParams.walletType);
        } else {
          AppPages.router.pop();

          showErrorMessage(context, l.message);
        }
      } else {
        showErrorMessage(context, Labels.errorHappened);
      }
    }, (data) {
      showSuccessMessage(context, Labels.subscribedSuccessfully);
    });
  }
}
//9.16 8/9/2024
