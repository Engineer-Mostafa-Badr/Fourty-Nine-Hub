import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_categories_use_case.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/shared/fourty_nine_shared_data.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/toggle_favorite_category.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

class MainCategoriesCubit extends Cubit<BasicState<List<MainCategoryEntity>>> {
  final GetMainCategoriesUseCase _getMainCategoriesUseCase;
  final FourtyNineSharedData _fourtyNineSharedData =
      FourtyNineSharedData.instance;
  final ToggleFavoriteCategoryUseCase _toggleFavoriteCategoryUseCase;

  MainCategoriesCubit(
    this._getMainCategoriesUseCase, this._toggleFavoriteCategoryUseCase,
  ) : super(const BasicState());

  Future<void> loadData(BuildContext context) async {
    emit(state.copyWith(status: StateStatus.loading));
    await UserCubit.to.getUser();
    if (_fourtyNineSharedData.mainCategories.isEmpty) {
      final user = UserCubit.to.state.data?.id;
      print('userId1$user');
      print('userId1$user');
      final result = await _getMainCategoriesUseCase(
          MainCategoriesParams(page: 1, limit: 100, userId: user??''));

      result.fold(
        (failure)
        {
          emit(state.copyWith(
            failure: failure,
            status: StateStatus.error,
          ));
          CliLogger.error('can\'t load main categories there is an error ${failure.toString()}');
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
      print('userId2${user?.id??''}');
      // emit(state.copyWith(status: StateStatus.loading));
      final result = await _getMainCategoriesUseCase(
          MainCategoriesParams(page: 1, limit: 100, userId: user?.id??''));

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
          result=data;
          emit(state.copyWith(status:StateStatus.success));
        });
    return result;
  }


}
