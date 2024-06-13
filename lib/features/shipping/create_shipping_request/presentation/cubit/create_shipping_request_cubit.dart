import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../core/error/failure.dart';
import '../../../../ride/RideRequest/data/models/address_search_params_model.dart';
import '../../../../ride/RideRequest/data/models/car_type_model.dart';
import '../../../../ride/RideRequest/data/models/google_search_results.dart';
import '../../../../ride/RideRequest/data/models/params/expected_price_params.dart';
import '../../../../ride/RideRequest/data/models/ride_request_model.dart';
import '../../../../ride/RideRequest/domain/entity/address_search_params_entity.dart';
import '../../../../ride/RideRequest/domain/usecases/request/get_near_by_places_usecase.dart';
import '../../../../subcategories/data/models/sub_category_model.dart';
import '../../domain/usecases/get_shipping_expected_price_usecase.dart';
import '../../domain/usecases/get_shipping_subcategories_usecase.dart';

part 'create_shipping_request_state.dart';

class CreateShippingRequestCubit extends Cubit<CreateShippingRequestState> {
  final fromAddressTextController = TextEditingController();
  final toAddressTextController = TextEditingController();
  final fromAddressFocusNode = FocusNode();
  final toAddressFocusNode = FocusNode();
  final GetNearByPlacesUseCase _getNearByPlacesUseCase;
  final GetShippingExpectedPriceUseCase _getShippingExpectedPriceUseCase;
  final GetShippingSubCategoriesUseCase _getShippingSubCategoriesUseCase;
  CreateShippingRequestCubit(
      this._getNearByPlacesUseCase,
      this._getShippingExpectedPriceUseCase,
      this._getShippingSubCategoriesUseCase)
      : super(const CreateShippingRequestState());

  void loadData() async {
    await getSubCategories();
  }

// ---- get subcategories
  Future<void> getSubCategories() async {
    final subCategories =
        await _getShippingSubCategoriesUseCase.call('');
    subCategories.fold((failure) {
      emit(state.copyWith(
        failure: failure,
        status: CreateShippingRequestStates.error,
      ));
    }, (response) {
      emit(state.copyWith(
          status: CreateShippingRequestStates.initState,
          subCategories: response));
      changeSubCategorySelection(item: response.first);
    });
  }

  void selectPickUpLocation({required AddressSearchParamsEntity item}) =>
      emit(state.copyWith(
          status: CreateShippingRequestStates.loading, fromAddress: item));
  // change subCategory selection
  void changeSubCategorySelection({
    required SubCategoryModel item,
  }) =>
      emit(state.copyWith(subCategory: item));
// search via google for near by addresses with string key
  Future<void> loadNearByPlaces({required String key}) async {
    emit(state.copyWith(status: CreateShippingRequestStates.loading));
    try {
      if (fromAddressTextController.text.isNotEmpty ||
          toAddressTextController.text.isNotEmpty) {
        final result = await _getNearByPlacesUseCase
            .call(AddressSearchParamsModel(address: key, lat: 0, lng: 0));
        result.fold((failure) {
          emit(state.copyWith(status: CreateShippingRequestStates.error));
        }, (nearByPlaces) {
          emit(state.copyWith(
              status: CreateShippingRequestStates.initState,
              nearByPlaces: nearByPlaces));
        });
      }
    } catch (e) {
      state.copyWith(
          status: CreateShippingRequestStates.error,
          errorMessage: e.toString());
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
      Navigator.pop(context);

      emit(state.copyWith(
          status: CreateShippingRequestStates.loading,
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

    final response = await _getShippingExpectedPriceUseCase.call(
        ExpectedPriceParams(
            fromLat: from.lat,
            fromLng: from.lng,
            toLat: to.lat,
            toLng: to.lng));

    response.fold(
        (failure) => emit(state.copyWith(
            status: CreateShippingRequestStates.error,
            errorMessage: 'Unable to get expected price',
            failure: failure)),
        (response) => emit(state.copyWith(
            status: CreateShippingRequestStates.loading,
            minimumPrice: response.price.toDouble(),
            offerPrice: response.price.toDouble(),
            distance: response.distance,
            time: response.duration)));
  }
  
}
