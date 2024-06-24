import 'package:bloc/bloc.dart';

import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/usecases/request/get_ride_sub_categories_use_case.dart';

import '../../../../subcategories/domain/entities/sub_category_entity.dart';
import '../../domain/entities/installment_entity.dart';
import '../../domain/usecases/get_installment_list_usecase.dart';

part 'installment_list_state.dart';

class InstallmentListCubit extends Cubit<InstallmentListState> {
  final GetInstallmentListUseCase _getInstallmentListUseCase;
  final GetSubCategoriesUseCase _getSubCategoriesUseCase;
  InstallmentListCubit(
      this._getInstallmentListUseCase, this._getSubCategoriesUseCase)
      : super(const InstallmentListState());

  void loadData() async {
    await getInstallmentsList();
    await getSubCategories();
  }

  Future<void> getInstallmentsList() async {
    final response = await _getInstallmentListUseCase.call(0);
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: InstallmentListStates.error)),
        (data) => emit(state.copyWith(
            installments: data, status: InstallmentListStates.initState)));
  }

  Future<void> getSubCategories() async {
    final response = await _getSubCategoriesUseCase.call('');
    response.fold(
        (failure) => emit(state.copyWith(
            failure: failure, status: InstallmentListStates.error)),
        (data) => emit(state.copyWith(
            subCategories: data, status: InstallmentListStates.initState)));
  }
   void changeSubCategory({required SubCategoryEntity v}) {
    emit(state.copyWith(selectedSubCategory: v));
  }

  void changeView({required bool isGrid}) {
    emit(state.copyWith(isGrid: isGrid));
  }
}
