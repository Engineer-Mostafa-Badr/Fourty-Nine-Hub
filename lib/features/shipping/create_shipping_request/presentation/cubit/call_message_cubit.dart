import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/shipping_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';

class CallMessageCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  CallMessageCubit({required this.repository}) : super(ShippingInitial());
  getCallMessage(
      {required String ownerId, required String subcategoryId}) async {
    var response = await repository.getCallMessage(
        ownerId: ownerId, subcategoryId: subcategoryId);
    response.fold(
      (l) {
        log(l.toString(), name: "lksjdflskdjlskdjfslkdfjsf");
        emit(FailureShippingState(failure: l));
      },
      (r) {
        emit(SuccessGetCallMessageState(data: r['data'] != "disable"));
      },
    );
  }
}
