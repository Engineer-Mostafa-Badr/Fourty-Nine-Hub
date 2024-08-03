import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/subscripe/domain/usecases/get_active_subscription_amounts.dart';
import 'package:fourtyninehub/features/subscripe/presentation/widgets/amounts.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/routes/pages.dart';
import '../../../../core/enums/base_status_enum.dart';
import '../../domain/usecases/check_if_user_subscribed_usecase.dart';
import '../../domain/usecases/get_subscription_plans_usecase.dart';
import '../../domain/usecases/subscribe_usecase.dart';
import '../widgets/subscription_plans.dart';

class SubscribeCubit extends Cubit<BasicState<bool>> {
  final CheckIfUserSubscribedUseCase _checkIfUserSubscribedUseCase;
  final GetSubscriptionPlansUseCase _getSubscriptionPlansUseCase;
  final SubscribeUseCase _subscribeUseCase;
  final GetActiveSubscriptionAmountsUseCase
      _getActiveSubscriptionAmountsUseCase;
  SubscribeCubit(
      this._checkIfUserSubscribedUseCase,
      this._getSubscriptionPlansUseCase,
      this._subscribeUseCase,
      this._getActiveSubscriptionAmountsUseCase)
      : super(const BasicState());

  void checkIfUserSubscribed(
      {List<WalletTypes>? paymentMenthods,
      required Function onSubscribed,
      required String subCategoryId}) async {
    showLoadingDialog(
        AppPages.router.configuration.navigatorKey.currentContext!);
    final response = await _checkIfUserSubscribedUseCase(subCategoryId);
    AppPages.router.pop();
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) async {
      if (data) {
        onSubscribed();
      } else {
        showLoadingDialog(
            AppPages.router.configuration.navigatorKey.currentContext!);
        final plansResponse = await _getSubscriptionPlansUseCase(subCategoryId);
        AppPages.router.pop();
        plansResponse.fold(
            (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
            (plans) {
          bottomSheet(
              context:
                  AppPages.router.configuration.navigatorKey.currentContext!,
              widget: SubscriptionPlansWidget(
                subscribePlans: plans,
                subCategoryId: subCategoryId,
                paymentMenthods: paymentMenthods,
              ));
        });
      }
    });
  }

  Future<void> showActiveSubscriptionAmounts({required WalletTypes walletType}) async {
    final response =
        await _getActiveSubscriptionAmountsUseCase(const NoParams());
    response.fold(
      (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
      (data) => bottomSheet(
        context: AppPages.router.configuration.navigatorKey.currentContext!,
        widget: SubscriptoinAmountsWidget(
          amounts: data,
          walletType: walletType,
        ),
      ),
    );
  }

  Future<void> subscribe({required SubscribeParams subscribeParams}) async {
    final response = await _subscribeUseCase(subscribeParams);
    response.fold((l) {
      if (l is ServerFailure) {
        if (l.statusCode == 400) {
          showActiveSubscriptionAmounts(walletType: subscribeParams.walletType);
        } else {
          AppPages.router.pop();

          showErrorMessage(
              AppPages.router.configuration.navigatorKey.currentContext!,
              l.message);
        }
      } else {
        showErrorMessage(
            AppPages.router.configuration.navigatorKey.currentContext!,
            Labels.errorHappened);
      }
    }, (data) {
      showSuccessMessage(
          AppPages.router.configuration.navigatorKey.currentContext!,
          Labels.subscribedSuccessfully);
      emit(state.copyWith(status: StateStatus.success));
    });
  }
}
