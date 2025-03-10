
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/activity_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/completed_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/expected_price_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/expected_price_params.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/get_location_from_address_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/running_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_activity_trips.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_completed_trips_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_all_running_trips_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_location_from_address_use_case.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_expexted_price_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_ride_governorates.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_shipping_categories_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../domain/entities/ride_category_entity.dart';
import '../../../domain/usecases/get_ride_categories_usecase.dart';

import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';



class RideCubit extends Cubit<RideState> {

  bool isComfort = false;
  bool isComfortIsAdded = false;
  bool isNonSmoker = false;
  bool isNonSmokerIsAdded = false;
  bool isAutoAccept = false;
  bool isAutoAcceptIsAdded = false;
  bool isRecord = false;


  final GetRideCategoriesUseCase getRideCategories;
  final GetShippingCategoriesUsecase getShippingCategoriesUsecase;
  final GetRideGovernoratesUseCase getRideGovernoratesUseCase;
  final GetLocationFromAddressUseCase getLocationFromAddressUseCase;
  final GetRideExpectedPriceUseCase getRideExpectedPriceUseCase;
  final GetAllCompletedTripsUseCase getAllCompletedTripsUseCase;
  final GetAllRunningTripsUseCase getAllRunningTripsUseCase;
  final GetAllActivityTripsUseCase getAllActivityTripsUseCase;

  RideCubit(
        this.getRideCategories,
        this.getShippingCategoriesUsecase,
        this.getRideGovernoratesUseCase,
        this.getLocationFromAddressUseCase,
        this.getRideExpectedPriceUseCase,
        this.getAllCompletedTripsUseCase,
        this.getAllRunningTripsUseCase,
        this.getAllActivityTripsUseCase,
      ) : super(const RideState()) {
    _fetchUserLocation();
  }

  Future<void> _fetchUserLocation() async {
    emit(state.copyWith(status: RideStates.loading));

    try {
      Position position = await _determinePosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      String address = placemarks.isNotEmpty
          ? "${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}"
          : "Unknown current Location";

      GetLocationFromAddressEntity currentLocation = GetLocationFromAddressEntity(
        lat: position.latitude,
        lng: position.longitude,
        address: address,
      );

      emit(state.copyWith(status: RideStates.success, currentLocation: currentLocation));
    } catch (e) {
      emit(state.copyWith(status: RideStates.error));
    }
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are permanently denied.");
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> fetchRideCategories(String userId) async {
    if (isClosed) return;  // Prevents state emission if the cubit is already disposed.
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, RideCategoryEntityUpdated> result = await getRideCategories(userId);

    if (isClosed) return;  // Double-check before emitting a state
    result.fold(
          (failure) => emit(state.copyWith(status: RideStates.error, failure: failure)),
          (rideCategory) => emit(state.copyWith(status: RideStates.success, rideCategory: rideCategory)),
    );
  }


  Future<void> fetchShippingCategories(String userId) async {
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, RideCategoryEntityUpdated> result = await getShippingCategoriesUsecase(userId);

    result.fold(
          (failure) => emit(state.copyWith(status: RideStates.error, failure: failure)),
          (rideCategory) => emit(state.copyWith(status: RideStates.success, shippingCategory: rideCategory)),
    );
  }


  Future<void> fetchRideGovernorates() async {
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, List<GovernorateEntity>> result = await getRideGovernoratesUseCase(const NoParams());

    result.fold(
          (failure) => emit(state.copyWith(status: RideStates.error, failure: failure)),
          (governorates) => emit(state.copyWith(status: RideStates.success, governorates: governorates)),
    );
  }

  Future<void> fetchRideExpectedPrice({required String id}) async {
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, RideExpectedPriceEntity> result = await getRideExpectedPriceUseCase(
      RideExpectedPriceParams(
        startLocation:[state.currentLocation!.lat!, state.currentLocation!.lng!],
        targetLocation: [state.toLocation!.lat!, state.toLocation!.lng!],
        comfort: false,
        id: id
      ),
    );

    log(result.toString());

    result.fold(
          (failure) => emit(state.copyWith(status: RideStates.error, failure: failure)),
          (rideExpectedPrice) => emit(state.copyWith(status: RideStates.success, rideExpectedPrice: rideExpectedPrice)),
    );
  }

  Future<void> fetchAllCompletedTrips({required int limit, required int page}) async {
    //emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, List<CompletedTripsEntity>> result =
    await getAllCompletedTripsUseCase(GetAllCompletedTripsUseCaseParams(limit, page));

    result.fold(
          (failure) {
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
          (completedTrips) {
        final List<CompletedTripsEntity> updatedTrips = page == 1
            ? completedTrips
            : [...?state.completedTrips, ...completedTrips];

        emit(state.copyWith(status: RideStates.success, completedTrips: updatedTrips));
      },
    );
  }


  Future<void> fetchAllRunningTrips({required int limit, required int page}) async {
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, List<RunningTripsEntity>> result =
    await getAllRunningTripsUseCase(GetAllRunningTripsUseCaseParams(limit, page));

    result.fold(
          (failure) {
        emit(state.copyWith(status: RideStates.error, failure: failure));
      },
          (runningTrips) {
        final List<RunningTripsEntity> updatedTrips = page == 1
            ? runningTrips
            : [...?state.runningTrips, ...runningTrips];

        emit(state.copyWith(status: RideStates.success, runningTrips: updatedTrips));
      },
    );
  }


  Future<void> fetchAllActivityTrips({required int limit, required int page}) async {
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, ActivityTripEntity> result = await getAllActivityTripsUseCase(
        GetAllActivityTripsUseCaseParams(limit: limit, page: page)
    );
    result.fold(
          (failure) => emit(state.copyWith(status: RideStates.error, failure: failure)),
          (activityTrips) => emit(state.copyWith(status: RideStates.success, activityTrips: activityTrips)),
    );

  }

  void updateFromLocation({required double lat, required double lng, required String address}) {

    GetLocationFromAddressEntity currentLocation = GetLocationFromAddressEntity(
      lat: lat,
      lng: lng,
      address: address,
    );

    emit(state.copyWith(status: RideStates.success, currentLocation: currentLocation));
  }

  void emitRefreshState(){
    emit(state.copyWith(status: RideStates.success));
  }

  void updateToLocation({required double lat, required double lng, required String address}) {

    GetLocationFromAddressEntity toLocation = GetLocationFromAddressEntity(
      lat: lat,
      lng: lng,
      address: address,
    );

    emit(state.copyWith(status: RideStates.success, toLocation: toLocation));
  }
}
