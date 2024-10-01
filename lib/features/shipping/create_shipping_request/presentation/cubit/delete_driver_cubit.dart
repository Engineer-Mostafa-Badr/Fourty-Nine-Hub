import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/shipping_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';

class DeleteDriverCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  DeleteDriverCubit({required this.repository}) : super(ShippingInitial());

  delete() async {
    var resposen = await repository.deleteDriver();
    resposen.fold(
      (l) {
        emit(FailureShippingState(failure: l));
      },
      (r) {
        emit(SuccessDeleteDriver(message: "Success Delete Driver"));
      },
    );
  }
}
