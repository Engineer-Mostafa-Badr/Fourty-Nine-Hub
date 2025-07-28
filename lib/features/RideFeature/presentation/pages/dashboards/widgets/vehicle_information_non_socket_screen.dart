import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/picker/date_picker_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../controllers/dashboards_cubit/dashboards_cubit.dart';
import '../../Register/widgets/upload_file_widget.dart';


class VehicleInformationNonSocketScreen extends StatelessWidget {
  const VehicleInformationNonSocketScreen({super.key, });


  @override
  Widget build(BuildContext context) {
    List<String> uploadFilesTitles = [
      LocaleKeys.vehiclePicture.localize,
      LocaleKeys.vehicleRegistrationCertificate.localize,
      LocaleKeys.backSideOfTheCertificate.localize,
    ];

    return BlocBuilder<DashboardsCubit, DashboardsState>(
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
                        BlocBuilder<DashboardsCubit, DashboardsState>(builder: (context, state) {
                      var cubit = context.read<DashboardsCubit>();
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
                                  icon: Icon(
                                    Icons.close,
                                    color: context.isDarkMode ? Colors.white : AppColors.GREY_DARK_COLOR,
                                  ),
                                )
                              ],
                            ),
                            const Sizer(),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * .22,
                              child: GridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                crossAxisCount: 3,
                                childAspectRatio: .50,
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
                            DatePickerTextField(color:context.isDarkMode?AppColors.GREY_DARK_COLOR:AppColors.GREYBG,initialDate: DateTime.now(), minDate: DateTime(1900), maxDate: DateTime(2090),onDateSelected: (date){
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
                        if(context.read<DashboardsCubit>().driverLicenseFormKey.currentState!.validate()) {
                          print("object");
                          if(context.read<DashboardsCubit>().state.vehiclePicture==null){
                            showErrorMessage(context, "Please select vehicle picture");
                            return;
                          }
                          if(context.read<DashboardsCubit>().state.vehicleFrontPicture==null){
                            showErrorMessage(context, "Please select front of vehicle license picture");
                            return;
                          }
                          if(context.read<DashboardsCubit>().state.vehicleBackPicture==null){
                            showErrorMessage(context, "Please select back of vehicle license picture");
                            return;
                          }
                          context.read<DashboardsCubit>().onSubmitUploadingCarLicense(context);
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
