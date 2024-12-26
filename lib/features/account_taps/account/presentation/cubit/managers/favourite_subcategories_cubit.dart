import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/usecases/get_favourite_subcategories_usecase.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_categories_use_case.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/toggle_sub_category_to_favorites_usecase.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

part 'favourite_sub_categories_state.dart';

class FavouriteSubCategoryCubit extends Cubit<FavouriteSubCategoryState> {
  final GetFavouriteSubCategoriesUseCase _getFavouriteSubCategoriesUseCase;
  final GetMainCategoriesUseCase _getMainCategoriesUseCase;
  final ToggleSubCategoryToFavoritesUseCase
      _toggleSubCategoryToFavoritesUseCase;

  FavouriteSubCategoryCubit(this._getFavouriteSubCategoriesUseCase,
      this._toggleSubCategoryToFavoritesUseCase, this._getMainCategoriesUseCase)
      : super(
          const FavouriteSubCategoryState(),
        );

  Future<void> load() async {
    emit(state.copyWith(status: StateStatus.loading));
    await loadData();
    await loadDataMain();
  }

  Future<void> loadData() async {
    emit(state.copyWith(status: StateStatus.loading));
    final result =
        await _getFavouriteSubCategoriesUseCase.call(const NoParams());
    emit(
      result.fold(
        (failure) => state.copyWith(
          failure: failure,
          status: StateStatus.error,
        ),
        (data) {
          return state.copyWith(
            status: StateStatus.success,
            data: data,
          );
        },
      ),
    );
  }

  //
  // Future<List<SubCategoryEntity>> getSubcategories(
  //     {required PaginationParams paginationParams}) async {
  //   List<SubCategoryEntity> data = [];
  //   emit(state.copyWith(status: StateStatus.loading));
  //   // await UserCubit.to.getUser();
  //   final user = UserCubit.to.state.data?.id;
  //   print('useeeerId===>$user}');
  //   final response = await _getFavouriteSubCategoriesUseCase(const NoParams());
  //   response.fold(
  //       (failure) =>
  //           emit(state.copyWith(failure: failure, status: StateStatus.error)),
  //       (r) => data = r);
  //
  //   return data;
  // }
  Future<void> loadDataMain() async {
    emit(state.copyWith(status: StateStatus.loading));
    await UserCubit.to.getUser();
    {
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
          emit(state.copyWith(status: StateStatus.success, mainCategory: r));
        },
      );
    }
  }

  Future<bool> toggleSubCategoryToFavorites(String subcategoryId) async {
    final response = await _toggleSubCategoryToFavoritesUseCase(subcategoryId);
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
}
