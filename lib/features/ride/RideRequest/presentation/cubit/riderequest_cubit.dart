import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/enums/main_services_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/address_search_params_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/params/expected_price_params.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/ride_request_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/usecases/request/get_expected_price_use_case.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/get_sub_categories_use_case.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/enums/ride_services_enum.dart';
import '../../../../../routes/routes.dart';
import '../../data/models/car_type_model.dart';
import '../../data/models/google_search_results.dart';
import '../../domain/entity/address_search_params_entity.dart';
import '../../domain/usecases/request/add_ride_request_usecase.dart';
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
  final GetSubCategoriesUseCase _getSubCategoriesUseCase;
  final AddRideRequestUseCase _addNormalRequest;

  RiderequestCubit(this._nearByPlacesUseCase, this._expectedPriceUseCase,
      this._getSubCategoriesUseCase, this._addNormalRequest)
      : super(const RiderequestState());

// get required initial data
  Future<void> loadData() async {
    emit(state.copyWith(status: RideRequestStatusesEnum.loading));
    // -------------------------------load subcategories ---------------------------
    final user = UserCubit.to.state.data?.id;
    final subCategories = await _getSubCategoriesUseCase.call(
        GetSubCategoriesParams(
            mainCategoryId: service.id,
            paginationParams: PaginationParams.basic(),
            userId: user ?? ''));
    subCategories.fold((failure) {
      emit(state.copyWith(
        failure: failure,
        status: RideRequestStatusesEnum.error,
      ));
    }, (response) {
      emit(state.copyWith(
          status: RideRequestStatusesEnum.initState, subCategories: response));
      changeSubCategorySelection(item: response.first);
    });

    // ---------------------------- load car types -------------------------
  }

  Future<void> getCarTypes() async {
    // final carTypes = await _getCarTypesUseCase.call('62c8ba9e8e28a58a3edf57e9');
    // carTypes.fold(
    //     (failure) => emit(state.copyWith(
    //         failure: failure, status: RideRequestStatusesEnum.error)),
    //     (response) => emit(state.copyWith(
    //         status: RideRequestStatusesEnum.initState,
    //         carTypes: response,
    //         selectedCarTypes: response)));
  }

  // change subCategory selection
  void changeSubCategorySelection({
    required SubCategoryEntity item,
  }) =>
      emit(state.copyWith(subCategory: item));

// Select pickup location from the map
  void selectPickUpLocation({required AddressSearchParamsEntity item}) =>
      emit(state.copyWith(
          status: RideRequestStatusesEnum.success, fromAddress: item));
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
    emit(state.copyWith(status: RideRequestStatusesEnum.loading));
    try {
      if (fromAddressTextController.text.isNotEmpty ||
          toAddressTextController.text.isNotEmpty) {
        final result = await _nearByPlacesUseCase
            .call(AddressSearchParamsModel(address: key, lat: 0, lng: 0));
        result.fold((failure) {
          emit(state.copyWith(status: RideRequestStatusesEnum.error));
        }, (nearByPlaces) {
          emit(state.copyWith(
              status: RideRequestStatusesEnum.success,
              nearByPlaces: nearByPlaces));
        });
      }
    } catch (e) {
      state.copyWith(
          status: RideRequestStatusesEnum.error, errorMessage: e.toString());
    }
  }

  // change expected price
  void changeExpectedPrice(String v) {
    emit(state.copyWith(offerPrice: double.tryParse(v) ?? state.offerPrice));
  }

  // change change phone number
  void changePhoneNumber(String v) {
    emit(state.copyWith(phone: v));
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
          status: RideRequestStatusesEnum.success,
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
        subCategoryId: state.subCategory?.id ?? '',
        fromLat: from.lat,
        fromLng: from.lng,
        toLat: to.lat,
        toLng: to.lng));

    response.fold(
        (failure) => emit(state.copyWith(
            status: RideRequestStatusesEnum.error,
            errorMessage: 'Unable to get expected price',
            failure: failure)),
        (response) => emit(state.copyWith(
            status: RideRequestStatusesEnum.success,
            minimumPrice: response.price.toDouble(),
            offerPrice: response.price.toDouble(),
            distance: response.distance,
            time: response.duration)));
  }

  // change autoaccept status
  void changeAutoAcceptStatus({required bool v}) {
    emit(
        state.copyWith(status: RideRequestStatusesEnum.success, autoAccept: v));
  }

  // add normal request

  void addNormalRequest({required BuildContext context}) async {
    final item = RideRequestModel(
        fromAddress: state.fromAddress?.address ?? '',
        toAddress: state.toAddress?.address ?? '',
        fromLat: state.fromAddress?.lat ?? 0,
        fromLng: state.fromAddress?.lng ?? 0,
        toLat: state.toAddress?.lat ?? 0,
        toLng: state.toAddress?.lng ?? 0,
        autoAccept: state.autoAccept,
        carTypes: [],
        categoryId: state.subCategory?.id ?? '',
        isAirConditioned: state.isAirConditioned,
        id: 'id',
        price: state.offerPrice,
        passengers: state.passengers ?? 1,
        phone: state.phone ?? '');
    final response = await _addNormalRequest(item);
    response.fold(
        (l) => emit(
            state.copyWith(status: RideRequestStatusesEnum.error, failure: l)),
        (data) {
      final service = item.service;

      if (service == RideServicesEnum.pickMe ||
          service == RideServicesEnum.comeWithYou) {
        context.push(Routes.MYADDS);
      } else {
        context.push(Routes.TRIPDETAILS);
      }
      emit(state.copyWith(status: RideRequestStatusesEnum.requestSent));
    });
  }
}
