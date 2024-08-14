import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/usecases/get_favourite_subcategories_usecase.dart';

import '../../../domain/entities/favourite_subcategory_entity.dart';

class FavouriteSubCategoryCubit
    extends Cubit<BasicState<List<FavouriteSubcategoryEntity>>> {
  final GetFavouriteSubCategoriesUseCase _getFavouriteSubCategoriesUseCase;

  FavouriteSubCategoryCubit(this._getFavouriteSubCategoriesUseCase)
      : super(
          const BasicState(),
        );

  void loadData() async {
    emit(state.copyWith(status: StateStatus.loading));
    final result =
        await _getFavouriteSubCategoriesUseCase.call(const NoParams());
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
