import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/driver_licence_part_model.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/part_model.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/parts_socket_model.dart';
import 'package:fourtyninehub/features/ride/Authentication/presentation/cubit/check_part_active_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/Identity_confirmation_card_register_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/behind_driver_license_card_register_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/driver_license_card_register_ride_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/expiration_date_driver_license_card_register_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/front_driver_license_card_register_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

class DriverLicencePartScreen extends StatelessWidget {
  DriverLicencePartScreen({super.key});
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final registerRider = context.read<RegisterRiderCubit>();
    return SharedScaffold(
      mainCategoryId: 1,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const Sizer(),
              DriverLicenseCardRegisterRideWidget(
                title: context.isArabic
                    ? "رقم رخصة السائق"
                    : "Driver's License Number",
                onChanged: (value) {
                  registerRider.model.driverLicenseNumber = value;
                },
              ),
              const Sizer(
                height: 30,
              ),
              const FrontDriverLicenseCardRegisterWidget(),
              const Sizer(
                height: 30,
              ),
              BehindDriverLicenseCardRegisterWidget(
                title: context.isArabic
                    ? "الجانب الخلفي من رخصة السائق"
                    : "Back side of driver's license",
                onTap: (image) {
                  registerRider.model.drivingImageBehind = image;
                },
              ),
              const Sizer(
                height: 30,
              ),
              ExpirationDateDriverLicenseCardRegisterWidget(
                onTap: (date) {
                  context.read<RegisterRiderCubit>().model.drvingExpiryDate =
                      date.toString();
                },
              ),
              const Sizer(
                height: 30,
              ),
              //
              const IdentityConfirmationCardRegisterWidget(),
              const Sizer(
                height: 40,
              ),
             Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: AppButton(
                  color: Colors.white,
                      backColor: AppColors.PRIMARY_COLOR,
                  label: LocaleKeys.submit.tr(),
                  onPressed: () async {
                    log("model.toJson()", name: 'lsdkfdkd029384jslkdjf');
                    if (formKey.currentState?.validate() == true) {
                    PartsSocketModel? checkModel =
                        await CacheManager.getSocketPartModel();
                    checkModel?.driverLicence = PartModel(
                        part: DriverLicencePartModel(
                            backDriverLicense:
                                registerRider.model.drivingImageBehind?.path,
                            driverLicenseNumber:
                                registerRider.model.driverLicenseNumber,
                            expirationDate: registerRider.model.drvingExpiryDate,
                            frontDriverLicense:
                                registerRider.model.drivingImageInFront?.path,
                            identify: registerRider.model.driverImage?.path),
                        active: true);
                    await CacheManager.saveSocketPartModel(checkModel!);
                
                    context.read<CheckPartActiveCubit>().check();
                    context.pop();
                    }
                  },
                ),
              ),
              Sizer(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }
}
