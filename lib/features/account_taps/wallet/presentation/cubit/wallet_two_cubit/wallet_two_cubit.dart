import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/main_category_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_history_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_subscription_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_subscription_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_history_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_usecase.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/main_category_use_case.dart';

import '../../../domain/usecases/request_withdraw_wallet_use_case.dart';
import '../wallet_cubit.dart';

part 'wallet_two_state.dart';

class WalletTwoCubit extends Cubit<WalletTwoState> {
  WalletTwoCubit(
    this._getWalletUseCase,
    this._walletHistoryUseCase,
    this._subscriptionWalletUseCase,
    this._mainCategoryUseCase,
    this._requestWithdrawWalletUseCase,
    // this._subCategoryUseCase,
    // this._deleteSubscriptionUseCase,
    // this._addSubscriptionUseCase,
  ) : super(const WalletTwoState(status: WalletTwoStates.initial));

  final GetWalletUseCase _getWalletUseCase;
  final GetWalletHistoryUseCase _walletHistoryUseCase;
  final GetSubscriptionWalletUseCase _subscriptionWalletUseCase;
  final MainCategoryUseCase _mainCategoryUseCase;
  final RequestWithdrawWalletUseCase _requestWithdrawWalletUseCase;

  final int limit = 30;
  bool hasReachedMax = false;
  // int page = 1;
  List<WalletHistoryEntity> histories = [];
  bool isLoading = false;

  Future<void> requestWithdrawal(
    context, {
    required String amount,
    required String phone,
    required String method,
  }) async {
    showLoadingDialog(context);
    // buttonRequestLoading = true;
    emit(state.copyWith(
      buttonRequestLoading: true,
    ));
    final response = await _requestWithdrawWalletUseCase.call(
      RequestWithdrawParams(amount: amount, phone: phone, method: method),
    );
    response.fold(
      (failure) {
        // buttonRequestLoading = false;
        Navigator.pop(context);
        emit(
          state.copyWith(
            // status: WalletTwoStates.failure,
            // failureMessage: getFailureMessage(failure, context),
            buttonRequestLoading: false,
            buttonRequestSuccess: false,
            buttonRequestErrMessage: getFailureMessage(failure, context),
          ),
        );
      },
      (data) {
        // buttonRequestLoading = false;
        // if (data) {
        //   emit(
        //     state.copyWith(
        //       // status: WalletTwoStates.failure,
        //       // failureMessage: getFailureMessage(failure, context),
        //       buttonRequestLoading: false,
        //       buttonRequestSuccess: false,
        //     ),
        //   );
        // }
        Navigator.pop(context);
        emit(
          state.copyWith(
            buttonRequestLoading: false,
            buttonRequestSuccess: true,
          ),
        );
      },
    );
  }

  Future<void> getHistories() async {
    // isLoading = true;
    final walletHistoryResponse = await _walletHistoryUseCase.call(
      WalletHistoryParams(
        page: state.page,
        limit: limit,
      ),
    );
    walletHistoryResponse.fold(
      (l) {
        // isLoading = false;
        emit(
          state.copyWith(
            failureHistory: l,
          ),
        );
      },
      (h) {
        // histories.addAll(h);
        // int page = state.page + 1;
        // if (h.length != limit) {
        //   hasReachedMax = true;
        // }
        // isLoading = false;
        emit(
          state.copyWith(
              historyStatus: WalletTwoStates.success,
              walletHistory:
                  state.walletHistory == null ? h : state.walletHistory! + h,
              page: state.page + 1,
              hasReachedMax: h.length != limit),
        );
      },
    );
  }

  Future<void> getAllDataWalletScreen(context) async {
    emit(state.copyWith(status: WalletTwoStates.loading));

    try {
      // Fetch Wallet
      final walletResponse = await _getWalletUseCase.call(const NoParams());
      final wallet = walletResponse.fold(
        (failure) => throw failure,
        (wallet) => wallet,
      );
      // Fetch Wallet History
      final walletHistoryResponse = await _walletHistoryUseCase.call(
        WalletHistoryParams(
          page: 1,
          limit: limit,
        ),
      );
      final walletHistory = walletHistoryResponse.fold(
        (failure) => throw failure,
        (histories) {
          this.histories = histories;
          if (histories.length != limit) {
            hasReachedMax = true;
          }
          return histories;
        },
      );

      // Fetch Wallet Subscription
      final subscriptionResponse =
          await _subscriptionWalletUseCase.call(const NoParams());
      final subscription = subscriptionResponse.fold(
        (failure) => throw failure,
        (subscription) => subscription,
      );

      // Fetch Main Category
      final mainCategoryResponse = await _mainCategoryUseCase.call(
        MainCategoryParams(
          paginationParams: PaginationParams(page: 1),
        ),
      );
      final mainCategory = mainCategoryResponse.fold(
        (failure) => throw failure,
        (mainCategories) => mainCategories,
      );

      // // Fetch sub category
      // final subCategoryResponse = await _subCategoryUseCase.call(
      //   MainCategoryParams(
      //     id: id,
      //     paginationParams: PaginationParams(),
      //   ),
      // );
      // final subCategory = subCategoryResponse.fold(
      //   (failure) => null,
      //   (subCategories) => subCategories,
      // );

      // Emit success state with all data
      // emit(
      //   WalletTwoSuccess(
      //     wallet: wallet,
      //     walletHistory: walletHistory,
      //     subscription: subscription,
      //     mainCategory: mainCategory,
      //   ),
      // );
      emit(state.copyWith(
        status: WalletTwoStates.success,
        wallet: wallet,
        walletHistory: walletHistory,
        subscription: subscription,
        mainCategory: mainCategory,
      ));
    } catch (failure) {
      // emit(
      //   WalletTwoError(
      //       failure: ServerFailure(
      //     message: e.toString(),
      //   )),
      // );
      String message = getFailureMessage(failure as Failure, context);
      emit(
        state.copyWith(
          status: WalletTwoStates.failure,
          failureMessage: message,
        ),
      );
    }
  }

  //
  // Future<void> getWallet() async {
  //   // final response = await _getWalletUseCase.call(const NoParams());
  //
  //   // response.fold(
  //   //   (failure) {
  //   //     emit(WalletError(failure: failure));
  //   //   },
  //   //   (wallet) {
  //   //     emit(WalletSuccess(wallet: wallet));
  //   //   },
  //   // );
  // }
  //
  // Future<void> fetchWalletHistory(
  //     {required int currentPage, required int pageSize}) async {
  //   // final response = await _walletHistoryUseCase.call(
  //   //   WalletHistoryParams(
  //   //     page: currentPage,
  //   //     limit: pageSize,
  //   //   ),
  //   // );
  //
  //   // response.fold(
  //   //   (failure) {
  //   //     emit(WalletTwoError(failure: failure));
  //   //   },
  //   //   (histories) {
  //   //     emit(WalletHistorySuccess(histories: histories));
  //   //   },
  //   // );
  // }
  //
  // Future<void> fetchWalletSubscription() async {
  //   // final response = await _subscriptionWalletUseCase.call(const NoParams());
  //
  //   // response.fold(
  //   //   (failure) {
  //   //     emit(WalletTwoError(failure: failure));
  //   //   },
  //   //   (subscription) {
  //   //     emit(WalletSubscriptionSuccess(subscriptions: subscription));
  //   //   },
  //   // );
  // }
  //
  // Future<void> fetchMainCategory({
  //   required PaginationParams paginationParams,
  // }) async {
  //   // final response = await _mainCategoryUseCase.call(
  //   //   MainCategoryParams(
  //   //     paginationParams: paginationParams,
  //   //   ),
  //   // );
  //
  //   // response.fold(
  //   //   (failure) {
  //   //     emit(WalletTwoError(failure: failure));
  //   //   },
  //   //   (mainCategories) {
  //   //     emit(WalletMainCategorySuccess(mainCategories: mainCategories));
  //   //   },
  //   // );
  // }

  @override
  void onChange(Change<WalletTwoState> change) {
    log('---------------- Change State ----------------');
    log('Current State: ${change.currentState}');
    log('---------------------------------------------');
    super.onChange(change);
  }
}
