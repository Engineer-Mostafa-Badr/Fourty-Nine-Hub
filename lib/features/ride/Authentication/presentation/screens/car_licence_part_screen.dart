import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/car_licence_part_model.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/part_model.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/parts_socket_model.dart';
import 'package:fourtyninehub/features/ride/Authentication/presentation/cubit/check_part_active_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/behind_car_license_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/car_image_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/car_model_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/expiration_date_driver_license_card_register_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/front_car_license_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/plate_number_register_card_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class CarLicencePartScreen extends StatelessWidget {
  CarLicencePartScreen({super.key});
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var registerRider = context.read<RegisterRiderCubit>();
    return SharedScaffold(
      mainCategoryId: 1,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const Sizer(
                height: 30,
              ),
              const CarModelRegisterCardWidget(),
              const Sizer(
                height: 30,
              ),
              const PlateNumberRegisterCardWidget(),
              const Sizer(
                height: 30,
              ),
              const FrontCarLicenseRegisterCardWidget(),
              const Sizer(
                height: 30,
              ),
              const BehindCarLicenseRegisterCardWidget(),
              const Sizer(
                height: 30,
              ),
              ExpirationDateDriverLicenseCardRegisterWidget(
                onTap: (date) {
                  context.read<RegisterRiderCubit>().model.licenseExpiryDate =
                      date.toString();
                },
              ),
              const Sizer(
                height: 30,
              ),
              const CarImageRegisterCardWidget(),
              const Sizer(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: AppButton(
                  color: Colors.white,
                  backColor: AppColors.PRIMARY_COLOR,
                  label: LocaleKeys.submit.tr(),
                  onPressed: () async {
      ManageVibration.vibrate();
                    log("model.toJson()", name: 'lsdkfdkd029384jslkdjf');
                    if (formKey.currentState?.validate() == true) {
                      PartsSocketModel? checkModel =
                          await CacheManager.getSocketPartModel();
                      checkModel?.carLicence = PartModel(
                          part: CarLicencePartModel(
                            carBrand: registerRider.model.vehicleBrand,
                            carModel: registerRider.model.vehicleModel ??
                                registerRider.model.carModel,
                            carYear: registerRider.model.vehicleYear,
                            carColor: registerRider.model.vehicleColor,
                            numberPlate: registerRider.model.plateInfo,
                            carRegisraion: registerRider
                                .model.carLicenseFrontImage
                                .toString(),
                            backVehicleLicense: registerRider
                                .model.carLicenseBehindImage
                                .toString(),
                            expiraionDate:
                                registerRider.model.licenseExpiryDate.toString(),
                            carImage: registerRider.model.carImage.toString(),
                          ),
                          active: true);
                      await CacheManager.saveSocketPartModel(checkModel!);
          
                      context.read<CheckPartActiveCubit>().check();
                      context.pop();
                    }
                  },
                ),
              ),
              const Sizer(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }
}