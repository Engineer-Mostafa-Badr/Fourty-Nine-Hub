import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../../ride/RideRequest/domain/usecases/request/get_ride_sub_categories_use_case.dart';
import '../../domain/entities/sub_category_entity.dart';

part 'subcategories_state.dart';

class SubcategoriesCubit extends Cubit<SubcategoriesState> {
  final GetSubCategoriesUseCase _getSubcategoriesUsecase;
  SubcategoriesCubit(this._getSubcategoriesUsecase)
      : super(const SubcategoriesState());

  void loadData() async {
    final response = await _getSubcategoriesUsecase.call('params');
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: SubcategoriesStates.error)),
        (data) => emit(state.copyWith(subCategories: data, 
        status: SubcategoriesStates.initState
        )));
  }
}
