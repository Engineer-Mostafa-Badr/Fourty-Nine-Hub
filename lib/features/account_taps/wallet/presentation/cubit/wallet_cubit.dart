import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/main_category_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/delete_subscription_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_history_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_usecase.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/wallet_state.dart';
import 'package:fourtyninehub/routes/pages.dart';

import '../../../../../common/models/public/pagination_params.dart';
import '../../domain/entities/wallet/wallet_entity.dart';
import '../../domain/entities/wallet/wallet_history_entity.dart';
import '../../domain/usecases/add_subscribe_use_case.dart';
import '../../domain/usecases/get_subscription_use_case.dart';
import '../../domain/usecases/main_category_use_case.dart';
import '../../domain/usecases/sub_category_use_case.dart';

class WalletCubit extends Cubit<WalletState> {
  final GetWalletUseCase _getWalletUseCase;
  final GetWalletHistoryUseCase _walletHistoryUseCase;
  final GetSubscriptionWalletUseCase _subscriptionWalletUseCase;
  final MainCategoryUseCase _mainCategoryUseCase;
  final SubCategoryUseCase _subCategoryUseCase;
  final DeleteSubscriptionUseCase _deleteSubscriptionUseCase;
  final AddSubscriptionUseCase _addSubscriptionUseCase;

  WalletEntity? da;

  List<WalletHistoryEntity> history = [];

  bool isLoadingMore = false;

  bool hasMoreData = true;

  int currentPage = 1;

  int pageSize = 10;
  WalletCubit(
    this._getWalletUseCase,
    this._walletHistoryUseCase,
    this._subscriptionWalletUseCase,
    this._mainCategoryUseCase,
    this._subCategoryUseCase,
    this._deleteSubscriptionUseCase,
    this._addSubscriptionUseCase,
  ) : super(const WalletState());
  Future<bool> addSubscription({required AddSubscriptionParams params}) async {
    bool success = false;
    var response = await _addSubscriptionUseCase(params);
    return response.fold((l) {
      success = false;
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: WalletStates.error));
      return success;
    }, (data) {
      success = true;
      fetchWalletSubscription();
      emit(state.copyWith(status: WalletStates.initial));
      return success;
    });
  }

  deleteSubscription({required String subscriptionId}) async {
    await _deleteSubscriptionUseCase(
        DeleteSubscriptionParams(subscriptionId: subscriptionId));
    fetchWalletSubscription();
  }

  Future<List<MainCategoryWalletEntity>> fetchMainCategoryWallet(
      {required PaginationParams paginationParams}) async {
    List<MainCategoryWalletEntity> category = [];
    final response = await _mainCategoryUseCase(
      MainCategoryParams(
        paginationParams: paginationParams,
      ),
    );
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: WalletStates.error));
    }, (data) {
      category = data;
    });
    return category;
  }

  Future<List<MainCategoryWalletEntity>> fetchSubCategoryWallet(
      {required PaginationParams paginationParams, required String id}) async {
    List<MainCategoryWalletEntity> category = [];
    final response = await _subCategoryUseCase(
      MainCategoryParams(
        id: id,
        paginationParams: paginationParams,
      ),
    );
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: WalletStates.error));
    }, (data) {
      category = data;
      // emit(state.copyWith(mainCategory: data,status: WalletStates.initial));
    });
    return category;
  }

  Future<void> fetchWalletHistory() async {
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _walletHistoryUseCase(
      WalletHistoryParams(page: currentPage, limit: pageSize),
    );

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: WalletStates.error));
      },
      (data) {
        history.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(history: history, status: WalletStates.success));
      },
    );
  }

  Future<void> fetchWalletSubscription() async {
    final response = await _subscriptionWalletUseCase(const NoParams());
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: WalletStates.error));
    }, (data) {
      emit(state.copyWith(subscription: data));
    });
  }

  Future<WalletEntity> getWallet() async {
    final response = await _getWalletUseCase.call(const NoParams());
    response.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: WalletStates.error));
    }, (data) {
      da = data;
      emit(state.copyWith(wallet: data));
    });
    return da!;
  }

  loadData() async {
    await getWallet();
    // await fetchWalletHistory();
    await fetchWalletSubscription();
    await loadInitialData();
  }

  Future<void> loadInitialData() async {
    emit(state.copyWith(status: WalletStates.loading));
    history.clear();
    currentPage = 1;
    hasMoreData = true;
    await fetchWalletHistory();
  }

  onSelectWallet(WalletTypes wallet) {
    emit(state.copyWith(
      selectedWallet: wallet,
    ));
  }
}
