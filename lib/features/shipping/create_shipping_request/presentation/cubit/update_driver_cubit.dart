import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/driver_register_request_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/register_request_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/shipping_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';

class UpdateDriverCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  UpdateDriverCubit({required this.repository}) : super(ShippingInitial());
  update(RegisterRequestModel model) async {
    var response = await repository.updateDriver(
      DriverRegisterRequestModel(
          carModel: model.model ?? "",
          categoryId: model.subCategoryEntity?.id.toString() ?? "",
          firstName: model.firstName ?? "",
          idNumber: model.idNumber ?? "",
          lastName: model.lastName ?? "",
          location: "",
          phone: model.phone ?? "",
          plateInformation: model.plateInfromation ?? ""),
    );
    response.fold(
      (l) {
        emit(FailureShippingState(failure: l));
      },
      (r) {
        emit(SuccessUpdateDriverState());
      },
    );
  }
}
