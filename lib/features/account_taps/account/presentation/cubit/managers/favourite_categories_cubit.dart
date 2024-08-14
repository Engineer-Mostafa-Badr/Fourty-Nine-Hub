import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/entities/favourite_category_entity.dart';
import '../../../domain/usecases/get_favourite_categories_usecase.dart';

class FavouriteCategoryCubit
    extends Cubit<BasicState<List<FavouriteCategoryEntity>>> {
  final GetFavouriteCategoriesUseCase _getMainCategoriesUseCase;

  FavouriteCategoryCubit(this._getMainCategoriesUseCase)
      : super(
          const BasicState(),
        );

  void loadData() async {
    emit(state.copyWith(status: StateStatus.loading));
    final result = await _getMainCategoriesUseCase.call(const NoParams());
    emit(
      result.fold(
        (failure) => state.copyWith(
          failure: failure,
          status: StateStatus.error,
        ),
        (data) => state.copyWith(
          status: StateStatus.success,
          data: data,
        ),
      ),
    );
  }
}
