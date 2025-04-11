import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/picker/date_picker_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/ride_register/ride_register_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/Driver/upload_rider_images.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

import '../widgets/upload_file_widget.dart';

class VehicleInformationScreen extends StatelessWidget {
  const VehicleInformationScreen({super.key, required this.params});
  final UploadRiderImagesParams params;

  @override
  Widget build(BuildContext context) {
    List<String> uploadFilesTitles = [
      LocaleKeys.vehiclePicture.localize,
      LocaleKeys.vehicleRegistrationCertificate.localize,
      LocaleKeys.backSideOfTheCertificate.localize,
    ];

    return BlocBuilder<RideRegisterCubit, RideRegisterState>(
      builder: (context,state) {
        return CustomScaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(30),
            child: HomeAppbar(),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 32,
                      left: 16,
                      right: 16,
                    ),
                    child:
                        BlocBuilder<RideRegisterCubit, RideRegisterState>(builder: (context, state) {
                      var cubit = context.read<RideRegisterCubit>();
                      return Form(
                        key: cubit.driverLicenseFormKey,
                        child: Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Label(
                                  text: LocaleKeys.vehicleInformation.localize,
                                  style: Styles.headerText(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => context.pop(),
                                  icon: const Icon(
                                    Icons.close,
                                    color: AppColors.GREY_DARK_COLOR,
                                  ),
                                )
                              ],
                            ),
                            const Sizer(),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).width * .45,
                              child: GridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                crossAxisCount: 3,
                                childAspectRatio: .75,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                children: List.generate(
                                  uploadFilesTitles.length,
                                  (index) => UploadFileWidget(
                                    title: uploadFilesTitles[index],
                                    onTap: () {
                                      if (index == 0) {
                                        cubit.onUploadVehiclePicture(context);
                                      } else if (index == 1) {
                                        cubit.onUploadVehicleFrontPicture(context);
                                      } else {
                                        cubit.onUploadVehicleBackPicture(context);
                                      }
                                    },
                                    imageUrl: index == 0
                                        ? state.vehiclePicture
                                        : index == 1
                                            ? state.vehicleFrontPicture
                                            : state.vehicleBackPicture,
                                  ),
                                ),
                              ),
                            ),

                            // DefaultTextFormField(
                            //   currentController: cubit.rideVehicleLicenseNumController,
                            //   fillColor: AppColors.GREYBG,
                            //   borderColor: Colors.transparent,
                            //   hint: LocaleKeys.licensePlateNumber.localize,
                            //   validator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return LocaleKeys.required.localize;
                            //     }
                            //     return null;
                            //   },
                            // ),
                            // const Sizer(),
                            DatePickerTextField(color:AppColors.GREYBG,initialDate: DateTime.now(), minDate: DateTime(1900), maxDate: DateTime(2090),onDateSelected: (date){
                              cubit.rideVehicleExpireDateController.text = DateFormat('yyyy-MM-dd').format(date??DateTime.now());
                            }, controller:cubit.rideVehicleExpireDateController,hintText: LocaleKeys.expireDate.localize,),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32,top: 8.0,right: 12,left: 12,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: AppColors.GREYBG,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    ),
                    const Sizer(),
                    InkWell(
                      onTap: () {
                        print("object");
                        if(context.read<RideRegisterCubit>().driverLicenseFormKey.currentState!.validate()) {
                          print("object");
                          if(context.read<RideRegisterCubit>().state.vehiclePicture==null){
                            showErrorMessage(context, "Please select vehicle picture");
                            return;
                          }
                          if(context.read<RideRegisterCubit>().state.vehicleFrontPicture==null){
                            showErrorMessage(context, "Please select front of vehicle license picture");
                            return;
                          }
                          if(context.read<RideRegisterCubit>().state.vehicleBackPicture==null){
                            showErrorMessage(context, "Please select back of vehicle license picture");
                            return;
                          }
                          context.read<RideRegisterCubit>().onSubmitUploadingCarLicense(context,params);
                          // if(state.vehiclePicture==null){
                          //   showErrorMessage(context, "Please select vehicle picture");
                          //   return;
                          // }

                        }
                      },
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Label(
                              text: LocaleKeys.submit.localize,
                              style: Styles.headerText(
                                fontWeight: FontWeight.w400,
                                color: AppColors.AUTH_CONTAINER_COLOR,
                              ),
                            ),
                            const Sizer(),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.AUTH_CONTAINER_COLOR,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
