import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/info_text.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/picture_optional_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/Identity_confirmation_card_register_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/behind_car_license_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/behind_driver_license_card_register_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/car_image_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/car_model_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/criminal_record_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/drag_analysis_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/driver_license_card_register_ride_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/expiration_date_driver_license_card_register_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/front_car_license_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/front_driver_license_card_register_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/more_information_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/plate_number_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/technical_examination_register_card_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/user_info_card_register_ride_widget.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class RideRegisterSocketScreen extends StatefulWidget {
  const RideRegisterSocketScreen({
    super.key,
    required this.formKey,
  });
  final GlobalKey<FormState> formKey;
  @override
  State<RideRegisterSocketScreen> createState() =>
      _RideRegisterSocketScreenState();
}

class _RideRegisterSocketScreenState extends State<RideRegisterSocketScreen> {
  late RegisterRiderCubit riderCubit;
  @override
  Widget build(BuildContext context) {
    final registerRider = context.read<RegisterRiderCubit>();
    return BlocConsumer<RegisterRiderCubit, RiderState>(
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const UserInfoCardRegisterRideWidget(),
              const Sizer(
                height: 30,
              ),
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
                  riderCubit.model.drivingImageBehind = image;
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
              ///////////
              const Sizer(
                height: 30,
              ),
              //
              BehindDriverLicenseCardRegisterWidget(
                onTap: (image) {
                  riderCubit.model.idImageInFront = image;
                },
                title: context.isArabic
                    ? "الجانب الامامي من البطاقة الشخصية"
                    : "ID card (front part)",
              ),
              const Sizer(
                height: 30,
              ),
              BehindDriverLicenseCardRegisterWidget(
                  onTap: (image) {
                    riderCubit.model.idImageInBehind = image;
                  },
                  title: context.isArabic
                      ? "البطاقة الشخصية (الجزاء الخلفي)"
                      : "ID card (back part)"),
              const Sizer(
                height: 30,
              ),
              DriverLicenseCardRegisterRideWidget(
                title: context.isArabic ? "رقم البطاقة الشخصية" : "ID number",
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
              //
              const IdentityConfirmationCardRegisterWidget(),

              BlocBuilder<PictureOptionalCubit, RiderState>(
                builder: (context, state) {
                  log(state.toString(), name: "lsdjfslkdjflskjfddddkdkdkk");
                  if (state is SuccessGetPictureOptionalState) {
                    if (state.value.dragAnalytics?.open ?? false) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.value.dragAnalytics?.open ?? false)
                            Column(
                              children: [
                                const Sizer(
                                  height: 30,
                                ),
                                const DragAnalysisRegisterCardWidget(),
                                const Sizer(
                                  height: 30,
                                ),
                                //
                                ExpirationDateDriverLicenseCardRegisterWidget(
                                  onTap: (date) {
                                    context
                                        .read<RegisterRiderCubit>()
                                        .model
                                        .dragAnalysisDate = date.toString();
                                  },
                                ),
                              ],
                            ),
                          // criminalRecord
                          if (state.value.criminalRecord?.open ?? false)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Sizer(
                                  height: 30,
                                ),
                                const CriminalRecordRegisterCardWidget(),
                                const Sizer(
                                  height: 30,
                                ),
                                //
                                ExpirationDateDriverLicenseCardRegisterWidget(
                                  onTap: (date) {
                                    context
                                        .read<RegisterRiderCubit>()
                                        .model
                                        .criminalRecordDate = date.toString();
                                  },
                                ),
                              ],
                            ),
                          //technicalExamination
                          if (state.value.technicalExamination?.open ?? false)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Sizer(
                                  height: 30,
                                ),
                                const TechnicalExaminationRegisterCardWidget(),
                                const Sizer(
                                  height: 30,
                                ),
                                //
                                ExpirationDateDriverLicenseCardRegisterWidget(
                                  onTap: (date) {
                                    context
                                            .read<RegisterRiderCubit>()
                                            .model
                                            .technicalExaminationDate =
                                        date.toString();
                                  },
                                ),
                              ],
                            )
                        ],
                      );
                    } else {
                      return Container(
                          // width: 150,
                          // height: 150,
                          // color: Colors.red,
                          );
                    }
                  } else {
                    return Container();
                  }
                },
              ),
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

              const MoreInformationRegisterCardWidget(),
              const Sizer(
                height: 30,
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
                    AppInfoText(
                      text: LocaleKeys.theApplicationDoesNotDeductAnyPercentage
                          .tr(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppInfoText(
                      text: LocaleKeys.youWillGetPoundsAnnually.tr(),
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
                        label: LocaleKeys.submit.tr(),
                        onPressed: () {
                          // registerRider.uploadImages();
                          if (context
                                  .read<RegisterRiderCubit>()
                                  .socketFormKey
                                  .currentState
                                  ?.validate() ==
                              true) {
                            registerRider.registerOne();
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
            ],
          ),
        );
      },
    );
  }
}

// المشاعر مش كلام
