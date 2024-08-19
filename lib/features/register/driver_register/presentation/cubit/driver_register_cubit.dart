import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/foundation.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/enums/ride_services_enum.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/car_type_model.dart';
import 'package:fourtyninehub/features/register/driver_register/data/models/rider_info_model.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

import '../../../../../core/enums/main_services_enum.dart';
import '../../../../../core/error/failure.dart';
import '../../../../ride/RideRequest/domain/usecases/request/get_car_types_use_case.dart';
import '../../../../subcategories/domain/usecases/get_sub_categories_use_case.dart';

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

  Future<void> loadData({required String id}) async {
    emit(state.copyWith(status: DriverRegisterStatuses.loading));
    try {
      // -------------------------------load subcategories ---------------------------
      final subCategories = await _getSubCategoriesUseCase.call(
          GetSubCategoriesParams(
              mainCategoryId: id, paginationParams: PaginationParams.basic()));
      subCategories.fold((failure) {
        emit(state.copyWith(
          failure: failure,
          status: DriverRegisterStatuses.error,
        ));
      }, (response) {
        emit(state.copyWith(
            status: DriverRegisterStatuses.initState,
            subCategories: response
                .where((element) =>
                    element.id != RideServicesEnum.comeWithYou.value() &&
                    element.id != RideServicesEnum.pickMe.value())
                .toList()));
        // changeSubCategorySelection(item: response.first);
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

  List<RideServicesEnum> handleAvailableServices() {
    if (captainOptions
        .contains(getRideServiceEnum(value: state.subCategory?.id ?? ''))) {
      return captainOptions;
    } else if (womenOptions
        .contains(getRideServiceEnum(value: state.subCategory?.id ?? ''))) {
      return womenOptions;
    }
    return [];
  }

  final captainOptions = [
    RideServicesEnum.captain,
    RideServicesEnum.intercity,
    RideServicesEnum.suv,
    RideServicesEnum.pickup,
    RideServicesEnum.premium,
  ];
  final womenOptions = [
    RideServicesEnum.womenOnly,
    RideServicesEnum.intercity,
    RideServicesEnum.premium,
  ];

  // change subCategory selection
  void changeSubCategorySelection({
    required SubCategoryEntity item,
  }) =>
      emit(state.copyWith(subCategory: item));

  // change subCategory selection
  void changeOptions({
    required RideServicesEnum item,
  }) {
    final list = state.selectedOptions ?? [];
    if (list.contains(item)) {
      list.remove(item);
    } else {
      list.add(item);
    }
    emit(state.copyWith(selectedOptions: list));
  }

  bool enterPrice() {
    final service = getRideServiceEnum(value: state.subCategory?.id ?? '');
    return service.isCaptain ||
        service.isScooter ||
        service.isTaxi ||
        service.isWomenOnly;
  }

  // change subCategory selection
  void changeCarTypeSelection({
    required CarTypeModel item,
  }) =>
      emit(state.copyWith(carType: item));
}
