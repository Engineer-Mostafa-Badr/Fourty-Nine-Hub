import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/balance/balance_data_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/gift_entities.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_balance_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_gifts_use_case.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/usecases/get_wallet_usecase.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_categories_use_case.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/shared/fourty_nine_shared_data.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_new_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/mark_messages_as_delivered_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/stop_listen_to_messages.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/toggle_favorite_category.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

part 'main_categories_state.dart';

class MainCategoriesCubit extends Cubit<MainCategoriesState> {
  final GetBalanceUseCases _balanceUseCases;
  final GetMainCategoriesUseCase _getMainCategoriesUseCase;
  final GetWalletUseCase _getWalletUseCase;
  final ListenToNewMessageUseCase _listenToNewMessageUseCase;
  final StopListenToMessagesUseCase _stopListenToNewMessagesUseCase;
  final MarkMessagesAsDeliveredUseCase _markMessagesAsDeliveredUseCase;
  final FourtyNineSharedData _fourtyNineSharedData =
      FourtyNineSharedData.instance;
  final ToggleFavoriteCategoryUseCase _toggleFavoriteCategoryUseCase;
  final GetWalletGiftsUseCase _giftUseCases;

  MainCategoriesCubit(
    this._getMainCategoriesUseCase,
    this._toggleFavoriteCategoryUseCase,
    this._giftUseCases,
    this._getWalletUseCase,
    this._balanceUseCases,
    this._listenToNewMessageUseCase,
    this._stopListenToNewMessagesUseCase,
    this._markMessagesAsDeliveredUseCase,
  ) : super(MainCategoriesState()) {
    _markMessagesAsDelivered();
  }

  Future<void> loadData() async {
    emit(state.copyWith(status: StateStatus.loading));
    await UserCubit.to.getUser();
    getWallet();
    fetchGiftWallet();
    fetchBalanceWallet();
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

  _markMessagesAsDelivered() {
    _listenToNewMessageUseCase((message) {
      _markMessagesAsDeliveredUseCase(
          MarkMessagesAsDeliveredParams(chatId: 'chatId'));
    });
  }

  Future<void> fetchGiftWallet() async {
    final response = await _giftUseCases.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: StateStatus.error));
    }, (data) {
      log('///////////////////////////////////////');
      log(data.giftWallet.userId);
      log('///////////////////////////////////////');
      emit(state.copyWith(gift: data));
    });
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
    final response = await _getWalletUseCase.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: StateStatus.error));
    }, (data) {
      emit(state.copyWith(wallet: data));
    });
  }

  Future<void> fetchBalanceWallet() async {
    final response = await _balanceUseCases.call(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: StateStatus.error));
    }, (data) {
      emit(state.copyWith(balance: data));
    });
  }
}
