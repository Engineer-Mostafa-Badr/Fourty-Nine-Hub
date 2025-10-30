import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/routes/pages.dart';
class SendOfferByDriverCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  SendOfferByDriverCubit({required this.repository}) : super(RiderInitial());
  send({required String id, required double price}) async {
    log(id, name: "lkdjflkjfldkjfff");
    log(price.toString(), name: "lkdjflksdjflkdjf");
    emit(LoadingRiderState());
    var response = await repository.createOfferByDriver(id: id, price: price);
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureRiderState(failure: l));
      },
      (r) {
        emit(SuccessSendOfferByDriverState());
      },
    );
  }
}
