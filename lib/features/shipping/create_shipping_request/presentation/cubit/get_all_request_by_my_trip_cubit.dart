import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/get_requests_for_loading_model/get_requests_for_loading_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/shipping_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';

class GetAllRequestByMyTripCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  GetAllRequestByMyTripCubit({required this.repository})
      : super(ShippingInitial());
  getAllRequest() async {
    var response = await repository.loadingTripRequests();
    response.fold(
      (l) {
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
