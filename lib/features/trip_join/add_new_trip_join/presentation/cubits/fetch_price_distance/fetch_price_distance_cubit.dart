// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/entities/trip_info_entity.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/usecases/fetch_price_distance_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'fetch_price_distance_state.dart';

class FetchPriceDistanceCubit extends Cubit<FetchPriceDistanceState> {
  final FetchPriceDistanceUsecase fetchPriceDistanceUsecase;
  TripInfoEntity? tripInfoEntity;
  FetchPriceDistanceCubit({
    required this.fetchPriceDistanceUsecase,
  }) : super(FetchPriceDistanceInitial());
  Future<void> fetchPriceDistance({
    required LatLng startLocation,
    required LatLng destiantionLocation,
  }) async {
    emit(FetchPriceDistanceLoading());
    final response = await fetchPriceDistanceUsecase.call(
      startLocation: startLocation,
      destiantionLocation: destiantionLocation,
    );
    response.fold(
      (Failure failure) => emit(
        FetchPriceDistanceFaild(errorMessage: Labels.errorHappened),
      ),
      (TripInfoEntity tripInfo) {
        tripInfoEntity = tripInfo;
        emit(
          FetchPriceDistanceSuccess(tripInfoEntity: tripInfo),
        );
      },
    );
  }
}
