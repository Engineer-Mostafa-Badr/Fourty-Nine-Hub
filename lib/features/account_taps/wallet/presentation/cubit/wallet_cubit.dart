import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/main_category_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/delete_subscription_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_history_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_usecase.dart';
import '../../../../../common/models/public/pagination_params.dart';
import '../../domain/entities/wallet/wallet_entity.dart';
import '../../domain/entities/wallet/wallet_history_entity.dart';
import '../../domain/entities/wallet/wallet_subscription_entity.dart';
import '../../domain/usecases/add_subscribe_use_case.dart';
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
  final DeleteSubscriptionUseCase _deleteSubscriptionUseCase;
  final AddSubscriptionUseCase _addSubscriptionUseCase;


  WalletCubit(this._getWalletUseCase, this._walletHistoryUseCase,
      this._subscriptionWalletUseCase, this._mainCategoryUseCase, this._subCategoryUseCase, this._deleteSubscriptionUseCase, this._addSubscriptionUseCase)
      : super(const WalletState());

   loadData() async {
    await getWallet();
   // await fetchWalletHistory();
    await fetchWalletSubscription();
  }

  WalletEntity? da;
  Future<WalletEntity> getWallet() async {
    final response = await _getWalletUseCase.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: WalletStates.error));
    }, (data) {
      da=data;
      emit(state.copyWith(wallet: data));
    });
    return da!;
  }

  Future<List<WalletHistoryEntity>> fetchWalletHistory({required PaginationParams paginationParams}) async {
    final response = await _walletHistoryUseCase(
      WalletHistoryParams(paginationParams: paginationParams),
    );
    List<WalletHistoryEntity> category = [];
    response.fold((l) {
      emit(state.copyWith(failure: l, status: WalletStates.error));
    }, (data) {
      category=data;
      emit(state.copyWith(history: data));
    });
    return category;
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


  deleteSubscription({
    required String subscriptionId
})async{
     await _deleteSubscriptionUseCase(
      DeleteSubscriptionParams(subscriptionId: subscriptionId)
    );
     fetchWalletSubscription();
}

  Future<void> addSubscription({
  required  AddSubscriptionParams params
  }) async {
    var response = await _addSubscriptionUseCase(params);
    return response.fold(
            (l) => emit(state.copyWith(failure: l, status: WalletStates.error)),
            (data) {
              fetchWalletSubscription();
          emit(state.copyWith(status: WalletStates.initial));

        }
    );

  }
}
