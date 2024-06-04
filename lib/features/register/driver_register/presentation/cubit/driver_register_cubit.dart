import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/foundation.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/car_type_model.dart';
import 'package:fourtyninehub/features/register/driver_register/data/models/rider_info_model.dart';

import '../../../../../core/enums/main_services_enum.dart';
import '../../../../../core/error/failure.dart';
import '../../../../RideRequest/domain/usecases/request/get_car_types_use_case.dart';
import '../../../../RideRequest/domain/usecases/request/get_ride_sub_categories_use_case.dart';
import '../../../../subcategories/data/models/sub_category_model.dart';

part 'driver_register_state.dart';

class DriverRegisterCubit extends Cubit<DriverRegisterState> {
  final formKey = GlobalKey<FormState>();
  final driverNameTextController = TextEditingController();
  final driverPhoneTextController = TextEditingController();
  final kmPriceTextController = TextEditingController();
  final GetCarTypesUseCase _getCarTypesUseCase;
  final GetSubCategoriesUseCase _getSubCategoriesUseCase;
  final service = MainServicesEnum.ride;

  DriverRegisterCubit(this._getCarTypesUseCase, this._getSubCategoriesUseCase)
      : super(const DriverRegisterState());

  Future<void> loadData() async {
    emit(state.copyWith(status: DriverRegisterStatuses.loading));
    try {
      // -------------------------------load subcategories ---------------------------
      final subCategories =
          await _getSubCategoriesUseCase.call(service.value());
      subCategories.fold((failure) {
        emit(state.copyWith(
          failure: failure,
          status: DriverRegisterStatuses.error,
        ));
      }, (response) {
        emit(state.copyWith(
            status: DriverRegisterStatuses.initState, subCategories: response));
        changeSubCategorySelection(item: response.first);
      });

      // ---------------------------- load car types -------------------------
      final carTypes =
          await _getCarTypesUseCase.call('62c8ba9e8e28a58a3edf57e9');
      carTypes.fold(
          (failure) => emit(state.copyWith(
              failure: failure, status: DriverRegisterStatuses.error)),
          (response) => emit(state.copyWith(
                status: DriverRegisterStatuses.initState,
                carTypes: response,
              )));
    } catch (e) {
      emit(state.copyWith(
        status: DriverRegisterStatuses.error,
      ));
    }
  }

  // change subCategory selection
  void changeSubCategorySelection({
    required SubCategoryModel item,
  }) =>
      emit(state.copyWith(subCategory: item));

  // change subCategory selection
  void changeCarTypeSelection({
    required CarTypeModel item,
  }) =>
      emit(state.copyWith(carType: item));
}
