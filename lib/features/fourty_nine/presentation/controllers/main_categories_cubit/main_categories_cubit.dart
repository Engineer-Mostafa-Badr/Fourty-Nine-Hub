import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/currency_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/any_cashback_usecase.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_currency_use_case.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_categories_use_case.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/shared/fourty_nine_shared_data.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/toggle_favorite_category.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../domain/entities/wallet_home_entity.dart';
import '../../../domain/use_cases/get_wallet_home_use_case.dart';

part 'main_categories_state.dart';

class MainCategoriesCubit extends Cubit<MainCategoriesState> {
  final GetMainCategoriesUseCase _getMainCategoriesUseCase;
  final AnyCashBackUseCase _anyCashBackUseCase;
  final FourtyNineSharedData _fourtyNineSharedData =
      FourtyNineSharedData.instance;
  final ToggleFavoriteCategoryUseCase _toggleFavoriteCategoryUseCase;
  final GetWalletHomeUseCase _getWalletHomeUseCase;
  final GetCurrencyUseCase _currencyUseCase;

  MainCategoriesCubit(
    this._getMainCategoriesUseCase,
    this._toggleFavoriteCategoryUseCase,
    this._getWalletHomeUseCase,
    this._currencyUseCase,
    this._anyCashBackUseCase,
  ) : super(MainCategoriesState());
  Future<void> loadData() async {
    emit(state.copyWith(status: StateStatus.loading));
    await UserCubit.to.getUser();
    getWallet();
    getCurrency();
    if (_fourtyNineSharedData.mainCategories.isEmpty) {
      final user = UserCubit.to.state.data?.id;
      print('userId1$user');
      print('userId1$user');
      final result = await _getMainCategoriesUseCase(
          MainCategoriesParams(page: 1, limit: 100, userId: user ?? ''));

      result.fold(
        (failure) {
          emit(state.copyWith(
            failure: failure,
            status: StateStatus.error,
          ));
          CliLogger.error(
              'can\'t load main categories there is an error ${failure.toString()}');
        },
        (r) {
          _fourtyNineSharedData.mainCategories = r;
          CliLogger.info('main categories loaded : ${r.length}');
          // CliLogger.info('shared main categories loaded : ${_fourtyNineSharedData.mainCategories.length}');
          // emit(state.copyWith(status: StateStatus.loading));
          emit(state.copyWith(status: StateStatus.success, data: r));
        },
      );
    } else {
      final user = UserCubit.to.state.data;
      print('userId2${user?.id ?? ''}');
      // emit(state.copyWith(status: StateStatus.loading));
      final result = await _getMainCategoriesUseCase(
          MainCategoriesParams(page: 1, limit: 100, userId: user?.id ?? ''));

      result.fold(
        (failure) => emit(state.copyWith(
          failure: failure,
          status: StateStatus.error,
        )),
        (r) {
          // _fourtyNineSharedData.mainCategories = r;
          // emit(state.copyWith(status: StateStatus.loading));
          emit(state.copyWith(status: StateStatus.success, data: r));
        },
      );
    }
  }

  Future<bool> toggleFavoriteMedicalService(String subcategoryId) async {
    final response = await _toggleFavoriteCategoryUseCase(subcategoryId);
    bool result = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (data) {
      result = data;
      emit(state.copyWith(status: StateStatus.success));
    });
    return result;
  }

  Future<bool> anyCashBack() async {
    final response = await _anyCashBackUseCase(const NoParams());
    bool result = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (data) {
      result = data;
      emit(state.copyWith(status: StateStatus.success));
    });
    return result;
  }

  Future<bool> toggleSubCategoryToFavorites(String subcategoryId) async {
    final response = await _toggleFavoriteCategoryUseCase(subcategoryId);
    bool result = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (data) {
      result = data;
      emit(state.copyWith(status: StateStatus.success));
    });
    return result;
  }

  Future<void> getWallet() async {
    final response = await _getWalletHomeUseCase.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: StateStatus.error));
    }, (data) {
      emit(state.copyWith(
        wallet: data,
      ));
      print("state.wallet?.giftWallet ${state.wallet?.giftWallet}");
    });
  }

  Future<void> getCurrency() async {
    final response = await _currencyUseCase.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: StateStatus.error));
    }, (data) {
      emit(state.copyWith(
        currency: data,
      ));
    });
  }
}
