// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/entities/trip_info_entity.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/usecases/fetch_price_distance_usecase.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
part 'fetch_price_distance_state.dart';

class FetchPriceDistanceCubit extends Cubit<FetchPriceDistanceState> {
  final FetchPriceDistanceUsecase fetchPriceDistanceUsecase;
  List<latlng.LatLng>? polyline;
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
      (Failure failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(
          FetchPriceDistanceFaild(
              errorMessage: getFailureMessage(failure, currentContext)),
        );
      },
      (TripInfoEntity tripInfo) {
        tripInfoEntity = tripInfo;
        polyline = tripInfo.polyline;
        print("in Fetch Price Cubit \n");
        print("tripInfoEntity  $tripInfoEntity \n");

        emit(
          FetchPriceDistanceSuccess(tripInfoEntity: tripInfoEntity!),
        );
      },
    );
  }
}
