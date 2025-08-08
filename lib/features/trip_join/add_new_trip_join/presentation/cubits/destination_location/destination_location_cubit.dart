// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/entities/location_entity.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/usecases/fetch_location_cordinates_usecase.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
part 'destination_location_state.dart';

class DestinationLocationCubit extends Cubit<DestinationLocationState> {
  final FetchLocationCordinatesUseCase fetchLocationCordinatesUseCase;
  DestinationLocationCubit({
    required this.fetchLocationCordinatesUseCase,
  }) : super(DestinationLocationInitial());

  LocationEntity? destinationLocation;

  Future<void> getDestinationLocation({required String address}) async {
    emit(DestinationLocationLoading());
    final response =
        await fetchLocationCordinatesUseCase.call(address: address);
    response.fold(
      (Failure failure) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
         emit(
        DestinationLocationFailed(
            errorMessage: _getErrorMessageFromFailure(failure)),
      );},
      (LocationEntity location) {
        destinationLocation = location;
        emit(
          DestinationLocationSuccess(locationEntity: location),
        );
      },
    );
  }

  String _getErrorMessageFromFailure(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    if (failure is UnauthorizedFailure) {
      return 'You are not authorized';
    }
    return 'Unkwon Error, Please try again later';
  }
}
