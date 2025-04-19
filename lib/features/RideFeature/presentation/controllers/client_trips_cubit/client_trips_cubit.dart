import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../health_feature/create_doctor/domain/entities/city.dart';
import '../../../../health_feature/create_doctor/domain/entities/governorate_entity.dart';
import '../../../../health_feature/create_doctor/domain/usecases/get_cities.dart';
import '../../../../health_feature/create_doctor/domain/usecases/get_governorates.dart';
import '../../../domain/entities/dashboards/trip_entity.dart';
import '../../../domain/entities/get_offers_entity.dart';
import '../../../domain/usecases/get_client_offers_usecase.dart';
import '../../../domain/usecases/get_loading_offers_usecase.dart';
import '../../../domain/usecases/make_loading_request_trip_usecase.dart';
import '../../../domain/usecases/make_non_tracking_request_trip_usecase.dart';

part 'client_trips_state.dart';

class ClientTripsCubit extends Cubit<ClientTripsState> {
  final MakeNonTrackingRequestTripUsecase makeNonTrackingRequestTripUsecase;
  final MakeLoadingRequestTripUsecase makeLoadingRequestTripUsecase;
  final GetClientOffersUsecase getClientOffersUseCase;
  final GetLoadingOffersUsecase getLoadingOffersUsecase;
  final GetCitiesUseCase _getCitiesUseCase;
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  ClientTripsCubit(
    this.makeNonTrackingRequestTripUsecase,
    this.getClientOffersUseCase,
    this.getLoadingOffersUsecase,
    this._getCitiesUseCase,
    this._getGovernoratesUseCase,
    this.makeLoadingRequestTripUsecase,
  ) : super(const ClientTripsState());

  Future<void> getCities(String governorateId) async {
    emit(state.copyWith(status: ClientTripsStates.loadingCities));
    final response = await _getCitiesUseCase.call(governorateId);

    response.fold(
      (failure) => emit(
        state.copyWith(
          status: ClientTripsStates.error,
        ),
      ),
      (data) =>
          emit(state.copyWith(status: ClientTripsStates.success, cities: data)),
    );
  }

  Future<void> getGovernorates() async {
    emit(state.copyWith(status: ClientTripsStates.loadingGovernorates));
    final response = await _getGovernoratesUseCase.call(const NoParams());
    response.fold(
        (failure) => emit(state.copyWith(
              status: ClientTripsStates.error,
            )), (data) {
      emit(state.copyWith(
          status: ClientTripsStates.successGovernorates, governorates: data));
    });
  }

  Future<void> getClientOffers(BuildContext context) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: ClientTripsStates.loading));

    final Either<Failure, GetOffersResponseEntity> result =
        await getClientOffersUseCase();

    if (isClosed) return;
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: ClientTripsStates.error, failure: failure));
      },
      (offers) {
        log("Suzccess");
        emit(state.copyWith(
            status: ClientTripsStates.success, offers: offers.data.offers));
        showSuccessMessage(
            context,
            context.isArabic
                ? "تم استرجاع العروض بنجاح"
                : "Offers retrieved successfully");
      },
    );
  }

  Future<void> getLoadingOffers(BuildContext context) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: ClientTripsStates.loading));

    final Either<Failure, GetOffersResponseEntity> result =
        await getLoadingOffersUsecase();

    if (isClosed) return;
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(status: ClientTripsStates.error, failure: failure));
      },
      (offers) {
        log("Suzccess");
        emit(state.copyWith(
            status: ClientTripsStates.success, offers: offers.data.offers));
        showSuccessMessage(
            context,
            context.isArabic
                ? "تم استرجاع العروض بنجاح"
                : "Offers retrieved successfully");
      },
    );
  }

  MakeNonTrackingRequestTripUsecaseParam makeNonTrackingTripParam =
      MakeNonTrackingRequestTripUsecaseParam();

  Future<void> makeNonTrackingRequestTrip(BuildContext context) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: ClientTripsStates.loadingSubmit));

    final Either<Failure, bool> result =
        await makeNonTrackingRequestTripUsecase(makeNonTrackingTripParam);

    if (isClosed) return;
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(
            status: ClientTripsStates.errorCreateTrip, failure: failure));
      },
      (settings) {
        log("Suzccess");
        emit(state.copyWith(status: ClientTripsStates.successCreateTrip));
      },
    );
  }

  MakeLoadingRequestTripUsecaseParam makeLoadingTripParam =
      MakeLoadingRequestTripUsecaseParam();

  Future<void> makeLoadingRequestTrip(BuildContext context) async {
    if (isClosed) {
      return;
    }
    emit(state.copyWith(status: ClientTripsStates.loadingSubmit));

    final Either<Failure, bool> result =
        await makeLoadingRequestTripUsecase(makeLoadingTripParam);

    if (isClosed) return;
    result.fold(
      (failure) {
        log("Failure ${getFailureMessage(failure, context)}");
        emit(state.copyWith(
            status: ClientTripsStates.errorCreateTrip, failure: failure));
      },
      (settings) {
        log("Suzccess");
        emit(state.copyWith(status: ClientTripsStates.successCreateTrip));
      },
    );
  }
}
