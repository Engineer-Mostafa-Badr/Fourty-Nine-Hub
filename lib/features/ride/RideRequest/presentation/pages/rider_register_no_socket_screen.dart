import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/info_text.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/Identity_confirmation_card_register_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/behind_car_license_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/behind_driver_license_card_register_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/car_image_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/driver_license_card_register_ride_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/expiration_date_driver_license_card_register_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/front_car_license_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/front_driver_license_card_register_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/plate_number_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/user_info_card_register_ride_widget.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';

class RiderRegisterNoSocketScreen extends StatefulWidget {
  const RiderRegisterNoSocketScreen({super.key, required this.formKey});
  final GlobalKey<FormState> formKey;
  @override
  State<RiderRegisterNoSocketScreen> createState() =>
      _RiderRegisterNoSocketScreenState();
}

class _RiderRegisterNoSocketScreenState
    extends State<RiderRegisterNoSocketScreen> {
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode idNumberFocusNode = FocusNode();
  FocusNode plateNumberFocusNode = FocusNode();
  FocusNode vehicleModelFocusNode = FocusNode();
  FocusNode vehicleBrandFocusNode = FocusNode();
  FocusNode vehicleColorFocusNode = FocusNode();
  FocusNode pricingPerKmFocusNode = FocusNode();
  FocusNode vehicleTypeFocusNode = FocusNode();
  FocusNode vehicleYearFocusNode = FocusNode();
  FocusNode carModelFocusNode = FocusNode();
  FocusNode model = FocusNode();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  TextEditingController plateNumberController = TextEditingController();
  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController vehicleBrandController = TextEditingController();
  TextEditingController vehicleColorController = TextEditingController();
  TextEditingController pricingPerKmController = TextEditingController();
  TextEditingController vehicleTypeController = TextEditingController();
  TextEditingController vehicleYearController = TextEditingController();
  TextEditingController carModelController = TextEditingController();
  bool smoker = false;

  @override
  Widget build(BuildContext context) {
    final registerRider = context.read<RegisterRiderCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: BlocConsumer<RegisterRiderCubit, RiderState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is LoadingShippingState) {
            return const Align(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.PRIMARY_COLOR,
                ),
              ),
            );
          }
          return SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const UserInfoCardRegisterRideWidget(),
                const Sizer(
                  height: 30,
                ),
                DriverLicenseCardRegisterRideWidget(
                  title: "رقم رخصة السائق",
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
                  title: "الجانب الخلفي من رخصة السائق",
                  onTap: (image) {
                    registerRider.model.drivingImageBehind = image;
                  },
                ),
                const Sizer(
                  height: 30,
                ),
                //
                ExpirationDateDriverLicenseCardRegisterWidget(
                  onTap: (date) {
                    context.read<RegisterRiderCubit>().model.idExpiryDate =
                        date.toString();
                  },
                ),
                const Sizer(
                  height: 30,
                ),
                //

                BehindDriverLicenseCardRegisterWidget(
                    onTap: (image) {
                      registerRider.model.idImageInFront = image;
                    },
                    title: "البطاقة الشخصية (الجزاء الامامي)"),
                const Sizer(
                  height: 30,
                ),
                BehindDriverLicenseCardRegisterWidget(
                    onTap: (image) {
                      registerRider.model.idImageInBehind = image;
                    },
                    title: "البطاقة الشخصية (الجزاء الخلفي)"),
                const Sizer(
                  height: 30,
                ),
                DriverLicenseCardRegisterRideWidget(
                  title: "رقم البطاقة الشخصية",
                  onChanged: (value) {
                    registerRider.model.idNumber = value;
                  },
                ),
                const Sizer(
                  height: 30,
                ),
                ExpirationDateDriverLicenseCardRegisterWidget(
                  onTap: (date) {
                    context.read<RegisterRiderCubit>().model.idExpiryDate =
                        date.toString();
                  },
                ),
                const Sizer(
                  height: 30,
                ),
                const IdentityConfirmationCardRegisterWidget(),

                const Sizer(
                  height: 30,
                ),
                //
                // const CarModelRegisterCardWidget(),

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
                const CarImageRegisterCardWidget(),
                const Sizer(
                  height: 30,
                ),
                const Sizer(
                  height: 30,
                ),
                DriverLicenseCardRegisterRideWidget(
                  title: "موديل السيارة",
                  onChanged: (value) {
                    context.read<RegisterRiderCubit>().model.carModel = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                FormField(
                  builder: (field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (field.hasError)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 8),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  field.errorText ?? "",
                                  style: Styles.mediumText(color: Colors.red),
                                ),
                              ),
                            ],
                          )
                      ],
                    );
                  },
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const AppInfoText(
                        text: Labels.theApplicationDoesNot,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const AppInfoText(
                        text: Labels.youWillGetPounds,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: AppButton(
                          backColor: AppColors.PRIMARY_COLOR,
                          textColor: Colors.white,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          label: Labels.submit,
                          onPressed: () {
                            log("message");
                            if (context.isUserLoggedIn) {
                              registerRider.registerTow(context);
                            } else {
                              return pleaseLoginDialog(context);

                              // context.push(Routes.LOGIN);
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )
              ]));
        },
      ),
    );
  }
}
