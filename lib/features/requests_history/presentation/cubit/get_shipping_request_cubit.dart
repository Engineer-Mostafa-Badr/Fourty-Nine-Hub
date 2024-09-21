import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/requests_history/data/models/shipping_request_model/shipping_request_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/shipping_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';

class GetShippingRequestCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  GetShippingRequestCubit({required this.repository})
      : super(ShippingInitial());
  getAllRequest() async {
    log("messagemessagemessage");
    var response = await repository.getShippingRequests();
    response.fold(
      (l) {
        emit(FailureShippingState(failure: l));
      },
      (r) {
        List<ShippingRequestModel> list = (r['data'] as List)
            .map(
              (e) => ShippingRequestModel.fromJson(e),
            )
            .toList();
        emit(SuccessGetShippingHistoryState(list: list));
      },
    );
  }
}
