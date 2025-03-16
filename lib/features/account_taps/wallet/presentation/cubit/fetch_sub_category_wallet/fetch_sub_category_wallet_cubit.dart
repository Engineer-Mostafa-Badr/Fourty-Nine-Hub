import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/main_category_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/main_category_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/sub_category_use_case.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

part 'fetch_sub_category_wallet_state.dart';

class FetchSubCategoryWalletCubit extends Cubit<FetchSubCategoryWalletState> {
  FetchSubCategoryWalletCubit(this._subCategoryUseCase)
      : super(FetchSubCategoryWalletInitial());
  final SubCategoryUseCase _subCategoryUseCase;

  Future<void> fetchSubCategoryWallet({
    required PaginationParams paginationParams,
    required String id,
  }) async {
    emit(FetchSubCategoryWalletLoading());
    final response = await _subCategoryUseCase(
      MainCategoryParams(
        id: id,
        paginationParams: paginationParams,
      ),
    );
    response.fold((l) {
      emit(FetchSubCategoryWalletError(failure: l));
    }, (data) {
      emit(FetchSubCategoryWalletSuccess(subCategory: data));
    });
  }

  void showSubscriptionPlans({
    required String name,
    required String id,
  }) {
    serviceLocator<SubscriptionController>().showSubscriptionPlans(
      wallets: [
        WalletTypes.mainWallet,
        WalletTypes.giftWallet,
        WalletTypes.balance,
      ],
      subCategoryId: id,
      title: name,
    );
  }

  // @override
  // void onChange(state) {
  //   log('FetchSubCategoryWalletCubit state: $state');
  //   super.onChange(state);
  // }
}
