// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/entities/location_entity.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/domain/usecases/fetch_location_cordinates_usecase.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
part 'starting_location_state.dart';

class StartingLocationCubit extends Cubit<StartingLocationState> {
  final FetchLocationCordinatesUseCase fetchLocationCordinatesUseCase;
  StartingLocationCubit({
    required this.fetchLocationCordinatesUseCase,
  }) : super(StartingLocationInitial());

  LocationEntity? startingLocation;
  Future<void> getStartingLocation({required String address}) async {
    emit(StartingLocationLoading());
    final response =
        await fetchLocationCordinatesUseCase.call(address: address);
    response.fold(
      (Failure failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(
          StartingLocationFailed(
              errorMessage: getFailureMessage(failure, currentContext)),
        );
      },
      (LocationEntity location) {
        startingLocation = location;
        emit(
          StartingLocationSuccess(locationEntity: location),
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
