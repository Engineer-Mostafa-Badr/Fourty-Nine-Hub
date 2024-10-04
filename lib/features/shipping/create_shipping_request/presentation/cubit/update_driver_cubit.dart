import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/driver_register_request_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/register_request_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/shipping_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';

class UpdateDriverCubit extends Cubit<ShippingState> {
  final ShippingRepository repository;
  UpdateDriverCubit({required this.repository}) : super(ShippingInitial());
  update(RegisterRequestModel model, ShippingCubit cubit) async {
    var data = DriverRegisterRequestModel(
        carModel: model.model ?? "",
        categoryId: model.subCategoryId?.toString() ?? "",
        firstName: model.firstName ?? "",
        idNumber: model.idNumber ?? "",
        lastName: model.lastName ?? "",
        location: "",
        phone: model.phone ?? "",
        plateInformation: model.plateInfromation ?? "");
    log(model.idImageBehind.toString(),
        name: "kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
    var response = await repository.updateDriver(data);
    response.fold(
      (l) {
        emit(FailureShippingState(failure: l));
      },
      (r) {
        emit(SuccessUpdateDriverState());
        updateImage(model, cubit);
      },
    );
  }

  updateImage(RegisterRequestModel model, ShippingCubit cubit) async {
    if (model.carImageInFront != null) {
      log("123123123123123 2222222222");
      await cubit.getCarImagesS3();
    } else if (model.idImageInFront != null) {
      await cubit.getS3IdImages();
    } else if (model.idImageBehind != null) {
      await cubit.getS3IdImages();
    } else if (model.drivingImageBehind != null) {
      await cubit.getDrivingLicenseS3();
    } else if (model.drivingImageInFront != null) {
      await cubit.getDrivingLicenseS3();
    } else if (model.licenseImageBehind != null) {
      await cubit.getLicenseS3();
    } else if (model.licenseImageInFront != null) {
      await cubit.getLicenseS3();
    }
  }
}
