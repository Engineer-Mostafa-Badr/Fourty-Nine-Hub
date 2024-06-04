import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/enums/main_services_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/address_search_params_model.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/params/expected_price_params.dart';
import 'package:fourtyninehub/features/RideRequest/data/models/ride_request_model.dart';
import 'package:fourtyninehub/features/RideRequest/domain/usecases/request/get_expected_price_use_case.dart';
import 'package:fourtyninehub/features/RideRequest/domain/usecases/request/get_ride_sub_categories_use_case.dart';
import 'package:go_router/go_router.dart';

import '../../../subcategories/data/models/sub_category_model.dart';
import '../../data/models/car_type_model.dart';
import '../../data/models/google_search_results.dart';
import '../../domain/entity/address_search_params_entity.dart';
import '../../domain/usecases/request/get_car_types_use_case.dart';
import '../../domain/usecases/request/get_near_by_places_usecase.dart';

part 'riderequest_state.dart';

class RiderequestCubit extends Cubit<RiderequestState> {
  final fromAddressTextController = TextEditingController();
  final toAddressTextController = TextEditingController();
  final fromAddressFocusNode = FocusNode();
  final toAddressFocusNode = FocusNode();
  final service = MainServicesEnum.ride;
  final GetNearByPlacesUseCase _nearByPlacesUseCase;
  final GetExpectedPriceUseCase _expectedPriceUseCase;
  final GetCarTypesUseCase _getCarTypesUseCase;
  final GetSubCategoriesUseCase _getSubCategoriesUseCase;
  RiderequestCubit(this._nearByPlacesUseCase, this._expectedPriceUseCase,
      this._getCarTypesUseCase, this._getSubCategoriesUseCase)
      : super(const RiderequestState());

// get required initial data
  Future<void> loadData() async {
    emit(state.copyWith(status: RideRequestStatusesEnum.loading));
    try {
      // -------------------------------load subcategories ---------------------------
      final subCategories =
          await _getSubCategoriesUseCase.call(service.value());
      subCategories.fold((failure) {
        emit(state.copyWith(
            failure: failure,
            status: RideRequestStatusesEnum.error,
            errorMessage: 'error message'));
      }, (response) {
        emit(state.copyWith(
            status: RideRequestStatusesEnum.initState,
            subCategories: response));
        changeSubCategorySelection(item: response.first);
      });

      // ---------------------------- load car types -------------------------
      final carTypes =
          await _getCarTypesUseCase.call('62c8ba9e8e28a58a3edf57e9');
      carTypes.fold(
          (failure) => emit(state.copyWith(
              failure: failure, status: RideRequestStatusesEnum.error)),
          (response) => emit(state.copyWith(
              status: RideRequestStatusesEnum.initState,
              carTypes: response,
              selectedCarTypes: response)));
    } catch (e) {
      emit(state.copyWith(
          status: RideRequestStatusesEnum.error, errorMessage: e.toString()));
    }
  }

  // change subCategory selection
  void changeSubCategorySelection({
    required SubCategoryModel item,
  }) =>
      emit(state.copyWith(subCategory: item));

// Select pickup location from the map
  void selectPickUpLocation({required AddressSearchParamsEntity item}) =>
      emit(state.copyWith(
          status: RideRequestStatusesEnum.isCameraMoving, fromAddress: item));
// change selectedCarTypes
  void selectCarType({required CarTypeModel item}) {
    var carList = state.selectedCarTypes;
    if (carList?.contains(item) ?? false) {
      carList?.remove(item);
    } else {
      carList?.add(item);
    }
    emit(state.copyWith(selectedCarTypes: carList));
  }

// change air condition value
  void changeAirConditionValue({required bool value}) =>
      emit(state.copyWith(isAirConditioned: value));
// search via google for near by addresses with string key
  Future<void> loadNearByPlaces({required String key}) async {
    emit(state.copyWith(status: RideRequestStatusesEnum.isNearByPlacesLoading));
    try {
      if (fromAddressTextController.text.isNotEmpty ||
          toAddressTextController.text.isNotEmpty) {
        final result = await _nearByPlacesUseCase
            .call(AddressSearchParamsModel(address: key, lat: 0, lng: 0));
        result.fold((failure) {
          emit(state.copyWith(status: RideRequestStatusesEnum.error));
        }, (nearByPlaces) {
          emit(state.copyWith(
              status: RideRequestStatusesEnum.isNearByPlacesLoaded,
              nearByPlaces: nearByPlaces));
        });
      }
    } catch (e) {
      state.copyWith(
          status: RideRequestStatusesEnum.error, errorMessage: e.toString());
    }
  }

// select pickup and drop off points manually
  void selectPlace(
      {required GoogleSearchResultModel item,
      required BuildContext context}) async {
    if (fromAddressFocusNode.hasFocus || state.fromAddress == null) {
      fromAddressTextController.text = item.formattedAddress ?? '';
      toAddressFocusNode.nextFocus();
      emit(state.copyWith(
          fromAddress: AddressSearchParamsEntity(
              address: item.formattedAddress!,
              lat: item.geometry!.location!.lat!,
              lng: item.geometry!.location!.lng!)));
    } else {
      toAddressTextController.text = item.formattedAddress ?? '';
      context.pop();

      emit(state.copyWith(
          status: RideRequestStatusesEnum.isFromAndToLocationSelected,
          toAddress: AddressSearchParamsEntity(
              address: item.formattedAddress!,
              lat: item.geometry!.location!.lat!,
              lng: item.geometry!.location!.lng!)));
      await getExpectedPrice();
    }
  }

  Future<void> getExpectedPrice() async {
    final from = state.fromAddress!;
    final to = state.toAddress!;

    final response = await _expectedPriceUseCase.call(ExpectedPriceParams(
        fromLat: from.lat, fromLng: from.lng, toLat: to.lat, toLng: to.lng));

    response.fold(
        (failure) => emit(state.copyWith(
            status: RideRequestStatusesEnum.error,
            errorMessage: 'Unable to get expected price',
            failure: failure)),
        (response) => emit(state.copyWith(
            status: RideRequestStatusesEnum.isTimeAndDistanceLoaded,
            minimumPrice: response.price.toDouble(),
            offerPrice: response.price.toDouble(),
            distance: response.displayedDistance,
            time: response.displayedTime)));
  }

  // change autoaccept status
  void changeAutoAcceptStatus({required bool v}) {
    emit(state.copyWith(
        status: RideRequestStatusesEnum.isAutoAcceptChanged, autoAccept: v));
  }
}
