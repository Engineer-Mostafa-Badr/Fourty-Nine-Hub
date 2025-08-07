import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/requests_history/domain/repositories/history_ride_repo.dart';
import 'package:fourtyninehub/features/requests_history/presentation/cubit/ratin_state.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

class RatingCubit extends Cubit<RatingState> {
  final RequestHistoryRepo repository;
  RatingCubit(this.repository) : super(InitalRatingState());
  rating({
    required int trip,
    required int driver,
    required int service,
    required String comment,
    required String driverId,
    required String loadingTripId,
    required String categoryId,
  }) async {
    log(trip.toString(), name: "trip");
    log(driver.toString(), name: "driver");
    log(service.toString(), name: "service");
    log(comment.toString(), name: "comment");
    log(driverId.toString(), name: "driverId");
    log(loadingTripId.toString(), name: "loadingTripId");
    log(categoryId.toString(), name: "categoryId");
    var resposne = await repository.rating(
      trip: trip,
      driver: driver,
      service: service,
      comment: comment,
      driverId: driverId,
      loadingTripId: loadingTripId,
      categoryId: categoryId,
    );
    resposne.fold(
      (error) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(error, currentContext));
        emit(FailiureRatingState(failure: error));
      },
      (data) {
        emit(SuccessRatingTripState());
      },
    );
  }
}
