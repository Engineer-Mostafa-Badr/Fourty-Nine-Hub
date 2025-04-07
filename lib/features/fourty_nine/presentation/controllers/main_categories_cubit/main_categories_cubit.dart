import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/utils/location_tracker.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/settings_dashboard_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/sub_category_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/dashboards/get_settings_dashboard_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/update_socket_location_usecase.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/currency_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/question_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/answer_question_usecase.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/any_cashback_usecase.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_currency_use_case.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_categories_custom_page_use_case.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_categories_use_case.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_category_details_usecase.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_question_usecase.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/shared/fourty_nine_shared_data.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/toggle_favorite_category.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../domain/entities/wallet_home_entity.dart';
import '../../../domain/use_cases/get_wallet_home_use_case.dart';

part 'main_categories_state.dart';

class MainCategoriesCubit extends Cubit<MainCategoriesState> {
  static MainCategoriesState to = AppPages
      .router.routerDelegate.navigatorKey.currentContext!
      .read<MainCategoriesState>();
  final GetMainCategoriesUseCase _getMainCategoriesUseCase;
  final GetQuestionUseCase _getQuestionUseCase;
  final AnswerQuestionUseCase _answerQuestionUseCase;
  final GetMainCategoriesCustomPageUseCase _categoriesCustomPageUseCase;
  final AnyCashBackUseCase _anyCashBackUseCase;
  final FourtyNineSharedData _fourtyNineSharedData =
      FourtyNineSharedData.instance;
  final ToggleFavoriteCategoryUseCase _toggleFavoriteCategoryUseCase;
  final GetWalletHomeUseCase _getWalletHomeUseCase;
  final GetCurrencyUseCase _currencyUseCase;
  final GetMainCategoryDetailsUseCase _getMainCategoryDetailsUseCase;
  final UpdateSocketLocationUseCase updateSocketLocationUseCase;
  final GetSettingsDashboardUsecase getSettingsDashboardUsecase;

  MainCategoriesCubit(
    this._getMainCategoriesUseCase,
    this._toggleFavoriteCategoryUseCase,
    this._getWalletHomeUseCase,
    this._currencyUseCase,
    this.updateSocketLocationUseCase,
    this._anyCashBackUseCase,
    this._categoriesCustomPageUseCase,
    this._getQuestionUseCase,
    this._answerQuestionUseCase,
    this._getMainCategoryDetailsUseCase,
    this.getSettingsDashboardUsecase,
  ) : super(MainCategoriesState());

  Future<void> loadDataCategory() async {
    await loadData();
    await getMainCategoryDetails();
    await getQuestion();
    await getMainCategoryCustomPage();
  }

  Future<void> getMainCategoryDetails() async {
    // if (user != null) {
    final response =
        await _getMainCategoryDetailsUseCase('62c8b5b09332225799fe335e');
    response.fold((failure) => emit(state.copyWith(status: StateStatus.error)),
        (data) {
      emit(state.copyWith(
        marriageMainCategory: data,
      ));
    });
    // }
  }

  Future<void> loadData() async {
    emit(state.copyWith(status: StateStatus.loading));
    await UserCubit.to.getUser();
    getWallet();
    getCurrency();
    getSettings();
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
        (r) async {
          _fourtyNineSharedData.mainCategories = r;
          CliLogger.info('main categories loaded in loadData : ${r.length}');
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

  Future<void> getMainCategoryCustomPage() async {
    emit(state.copyWith(status: StateStatus.loading));
    await UserCubit.to.getUser();
    getWallet();
    getCurrency();
    if (_fourtyNineSharedData.mainCategories.isEmpty) {
      final user = UserCubit.to.state.data?.id;
      print('userId2 $user');
      print('userId@ $user');
      final result = await _categoriesCustomPageUseCase(
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
          CliLogger.info('custom page categories loaded : ${r.length}');
          // CliLogger.info('shared main categories loaded : ${_fourtyNineSharedData.mainCategories.length}');
          // emit(state.copyWith(status: StateStatus.loading));
          emit(state.copyWith(status: StateStatus.success, customPage: r));
        },
      );
    } else {
      final user = UserCubit.to.state.data;
      print('userId2 ${user?.id ?? ''}');
      // emit(state.copyWith(status: StateStatus.loading));
      final result = await _categoriesCustomPageUseCase(
          MainCategoriesParams(page: 1, limit: 100, userId: user?.id ?? ''));

      result.fold(
        (failure) => emit(state.copyWith(
          failure: failure,
          status: StateStatus.error,
        )),
        (r) {
          _fourtyNineSharedData.mainCategories = r;
          // emit(state.copyWith(status: StateStatus.loading));
          emit(state.copyWith(status: StateStatus.success, customPage: r));
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

  Future<void> getQuestion() async {
    final response = await _getQuestionUseCase(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (data) {
      emit(state.copyWith(question: data, status: StateStatus.success));
    });
  }

  Future<void> answerQuestion(
      {required String id,
      required String answer,
      required BuildContext context}) async {
    final response = await _answerQuestionUseCase(
        AnswerQuestionParams(id: id, answer: answer));
    response.fold((failure) {
      context.pop();
      showErrorMessage(context, getFailureMessage(failure, context));

      emit(state.copyWith(failure: failure, status: StateStatus.error));
    }, (data) {
      context.pop();
      showSuccessMessage(context, LocaleKeys.successSubmit.localize);
      emit(state.copyWith(status: StateStatus.success));
    });
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

  Future<void> getSettings() async {
    if (isClosed) {
      return;
    }

    final Either<Failure, SettingsDashboardEntityResponse> result =
    await getSettingsDashboardUsecase(const NoParams());

    if (isClosed) return;
    result.fold(
          (failure) {
        emit(state.copyWith(status: StateStatus.error, failure: failure));
      },
          (settings) {
        log("Suzccess");

        bool isReady = isServiceAvailable(settings);
        log("SuccessIsReady : $isReady");
        if(isReady){
          updateDriverLocation();
        }
        emit(state.copyWith(
            status: StateStatus.success,));
      },
    );
  }

  bool isServiceAvailable(SettingsDashboardEntityResponse data) {
    // Check if isReady is true
    if (data.data.isReady == true) {
      // Check if any category is active
      List<SubCategoryEntity> categories = data.data.categoryIds;
      return categories.any((category) => category.isActive == true);
    }
    return false;
  }

  Future<void> emitDriverLocation({required double lat,required double long}) async {
    final result = await updateSocketLocationUseCase(
        UpdateSocketLocationParams(latitude: lat, longitude: long)
    );
    result.fold(
            (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
            (r) async {
          if(r==true)log("Location Updated Successfully");
        });
  }

  updateDriverLocation(){
    final locationService = LocationService();

    locationService.startLocationTracking();

    // Listen for new locations (only when moved at least 1m)
    locationService.locationUpdates.listen((position) {
      emitDriverLocation(lat: position.latitude, long: position.longitude);
      Fluttertoast.showToast(
          msg: "New location (moved at least 1m): ${position.latitude}, ${position.longitude}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
      print('New location (moved at least 1m): ${position.latitude}, ${position.longitude}');
    });
  }
}
