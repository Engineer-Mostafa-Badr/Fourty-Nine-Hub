import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/main_category_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_history_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_usecase.dart';
import '../../../../../common/models/public/pagination_params.dart';
import '../../domain/entities/wallet/wallet_entity.dart';
import '../../domain/entities/wallet/wallet_history_entity.dart';
import '../../domain/entities/wallet/wallet_subscription_entity.dart';
import '../../domain/usecases/get_subscription_use_case.dart';
import '../../domain/usecases/main_category_use_case.dart';
import '../../domain/usecases/sub_category_use_case.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final GetWalletUseCase _getWalletUseCase;
  final GetWalletHistoryUseCase _walletHistoryUseCase;
  final GetSubscriptionWalletUseCase _subscriptionWalletUseCase;
  final MainCategoryUseCase _mainCategoryUseCase;
  final SubCategoryUseCase _subCategoryUseCase;


  WalletCubit(this._getWalletUseCase, this._walletHistoryUseCase,
      this._subscriptionWalletUseCase, this._mainCategoryUseCase, this._subCategoryUseCase)
      : super(const WalletState());

  void loadData() async {
    await getWallet();
    await fetchWalletHistory();
    await fetchWalletSubscription();
  }

  Future<void> getWallet() async {
    final response = await _getWalletUseCase.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: WalletStates.error));
    }, (data) {
      emit(state.copyWith(wallet: data));
    });
  }

  Future<void> fetchWalletHistory() async {
    final response = await _walletHistoryUseCase(
      WalletHistoryParams(
        page: 1,
        limit: 20,
      ),
    );
    response.fold((l) {
      emit(state.copyWith(failure: l, status: WalletStates.error));
    }, (data) {
      // print('///////////////////////////////////////');
      // print(data.giftWallet.userId);
      // print('///////////////////////////////////////');
      emit(state.copyWith(history: data));
    });
  }

  Future<void> fetchWalletSubscription() async {
    final response = await _subscriptionWalletUseCase(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: WalletStates.error));
    }, (data) {
      emit(state.copyWith(subscription: data));
    });
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
      emit(state.copyWith(failure: l, status: WalletStates.error));
    }, (data) {
      category = data;
    });
    return category;
  }

  Future<List<MainCategoryWalletEntity>> fetchSubCategoryWallet(
      {required PaginationParams paginationParams,required String id}) async {
    List<MainCategoryWalletEntity> category = [];
    final response = await _subCategoryUseCase(
      MainCategoryParams(
        id: id,
        paginationParams: paginationParams,
      ),
    );
    response.fold((l) {
      emit(state.copyWith(failure: l, status: WalletStates.error));
    }, (data) {
      category = data;
      // emit(state.copyWith(mainCategory: data,status: WalletStates.initial));
    });
    return category;
  }
}
