import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/main_category_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_history_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_subscription_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_subscription_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_history_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_usecase.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/main_category_use_case.dart';
part 'wallet_two_state.dart';

class WalletTwoCubit extends Cubit<WalletTwoState> {
  WalletTwoCubit(
    this._getWalletUseCase,
    this._walletHistoryUseCase,
    this._subscriptionWalletUseCase,
    this._mainCategoryUseCase,
    // this._subCategoryUseCase,
    // this._deleteSubscriptionUseCase,
    // this._addSubscriptionUseCase,
  ) : super(WalletTwoInitial());

  final GetWalletUseCase _getWalletUseCase;
  final GetWalletHistoryUseCase _walletHistoryUseCase;
  final GetSubscriptionWalletUseCase _subscriptionWalletUseCase;
  final MainCategoryUseCase _mainCategoryUseCase;
  // final SubCategoryUseCase _subCategoryUseCase;
  // final DeleteSubscriptionUseCase _deleteSubscriptionUseCase;
  // final AddSubscriptionUseCase _addSubscriptionUseCase;

  Future<void> getAllDataWalletScreen() async {
    emit(WalletTwoLoading());

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
          limit: 10,
        ),
      );
      final walletHistory = walletHistoryResponse.fold(
        (failure) => throw failure,
        (histories) => histories,
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
      emit(
        WalletTwoSuccess(
          wallet: wallet,
          walletHistory: walletHistory,
          subscription: subscription,
          mainCategory: mainCategory,
        ),
      );
    } catch (e) {
      emit(
        WalletTwoError(
            failure: ServerFailure(
          message: e.toString(),
        )),
      );
    }
  }

  Future<void> getWallet() async {
    // final response = await _getWalletUseCase.call(const NoParams());

    // response.fold(
    //   (failure) {
    //     emit(WalletError(failure: failure));
    //   },
    //   (wallet) {
    //     emit(WalletSuccess(wallet: wallet));
    //   },
    // );
  }

  Future<void> fetchWalletHistory(
      {required int currentPage, required int pageSize}) async {
    // final response = await _walletHistoryUseCase.call(
    //   WalletHistoryParams(
    //     page: currentPage,
    //     limit: pageSize,
    //   ),
    // );

    // response.fold(
    //   (failure) {
    //     emit(WalletTwoError(failure: failure));
    //   },
    //   (histories) {
    //     emit(WalletHistorySuccess(histories: histories));
    //   },
    // );
  }

  Future<void> fetchWalletSubscription() async {
    // final response = await _subscriptionWalletUseCase.call(const NoParams());

    // response.fold(
    //   (failure) {
    //     emit(WalletTwoError(failure: failure));
    //   },
    //   (subscription) {
    //     emit(WalletSubscriptionSuccess(subscriptions: subscription));
    //   },
    // );
  }

  Future<void> fetchMainCategory({
    required PaginationParams paginationParams,
  }) async {
    // final response = await _mainCategoryUseCase.call(
    //   MainCategoryParams(
    //     paginationParams: paginationParams,
    //   ),
    // );

    // response.fold(
    //   (failure) {
    //     emit(WalletTwoError(failure: failure));
    //   },
    //   (mainCategories) {
    //     emit(WalletMainCategorySuccess(mainCategories: mainCategories));
    //   },
    // );
  }

  @override
  void onChange(Change<WalletTwoState> change) {
    log('---------------- Change State ----------------');
    log('Current State: ${change.currentState}');
    log('---------------------------------------------');
    super.onChange(change);
  }
}
