import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/get_requests_for_loading_model/get_requests_for_loading_model.dart';
import '../../data/repositories/shipping_repository.dart';
import 'shipping_state.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
class GetAllRequestByMyTripCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  GetAllRequestByMyTripCubit({required this.repository})
      : super(ShippingInitial());
  getAllRequest() async {
    var response = await repository.loadingTripRequests();
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureShippingState(failure: l));
      },
      (r) {
        log(r.toString(), name: "laksjdlskjdlskjffff");
        List<GetRequestsForLoadingModel> list = (r['data'] as List)
            .map(
              (e) => GetRequestsForLoadingModel.fromJson(e),
            )
            .toList();
        emit(SuccessGetLoadingTripRequests(request: list));
      },
    );
  }
}
