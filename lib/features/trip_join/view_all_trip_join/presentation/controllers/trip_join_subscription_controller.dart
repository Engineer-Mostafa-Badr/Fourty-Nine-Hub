// import 'package:flutter/material.dart';
// import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
// import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
// import 'package:fourtyninehub/core/messages/messages.dart';
// import 'package:fourtyninehub/features/subscripe/domain/usecases/check_if_user_subscribed_usecase.dart';
// import 'package:fourtyninehub/features/subscripe/domain/usecases/get_active_subscription_amounts.dart';
// import 'package:fourtyninehub/features/subscripe/domain/usecases/get_subscription_plans_usecase.dart';
// import 'package:fourtyninehub/features/subscripe/domain/usecases/subscribe_usecase.dart';
// import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
// import 'package:fourtyninehub/features/subscripe/presentation/widgets/subscription_plans.dart';
// import 'package:fourtyninehub/res/strings/labels.dart';
// import 'package:fourtyninehub/routes/pages.dart';

// class TripJoinSubscriptionCotroller extends SubscriptionController {
//   final CheckIfUserSubscribedUseCase _checkIfUserSubscribedUseCase;
//   final GetSubscriptionPlansUseCase _getSubscriptionPlansUseCase;
//   final SubscribeUseCase _subscribeUseCase;
//   final GetActiveSubscriptionAmountsUseCase _getActiveSubscriptionAmountsUseCase;
//   TripJoinSubscriptionCotroller(
//     this._checkIfUserSubscribedUseCase,
//     this._getSubscriptionPlansUseCase,
//     this._subscribeUseCase,
//     this._getActiveSubscriptionAmountsUseCase,
//   ) : super(
//           _checkIfUserSubscribedUseCase,
//           _getSubscriptionPlansUseCase,
//           _subscribeUseCase,
//           _getActiveSubscriptionAmountsUseCase,
//         );

//   @override
//   Future<void> showSubscriptionPlans({List<WalletTypes>? wallets, required String subCategoryId}) async {
//     showLoadingDialog(context);
//     final plansResponse = await _getSubscriptionPlansUseCase(subCategoryId);
//     AppPages.router.pop();
//     plansResponse.fold(
//         (l) => showErrorMessage(
//               context,
//               Labels.errorHappened,
//             ), (plans) {
//       bottomSheet(
//           context: context,
//           backColor: Theme.of(context).scaffoldBackgroundColor,
//           widget: SubscriptionPlansWidget(
//             subscribePlans: plans,
//             subCategoryId: subCategoryId,
//             paymentMenthods: wallets,
//           ));
//     });
//   }
// }
