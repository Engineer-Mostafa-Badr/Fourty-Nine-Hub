import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/picker/date_picker_field.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
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

import '../widgets/upload_file_widget.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class DriversLicenseScreen extends StatelessWidget {
  const DriversLicenseScreen({super.key, required this.params});
  final UploadRiderImagesParams params;
  @override
  Widget build(BuildContext context) {
    List<String> uploadFilesTitles = [
      LocaleKeys.driversLicense.localize,
      LocaleKeys.backOfTheLicense.localize,
      LocaleKeys.aSelfieWithTheLicense.localize,
    ];
    List<String> uploadLoadingFilesTitles = [
      LocaleKeys.driversLicense.localize,
      LocaleKeys.backOfTheLicense.localize,
      LocaleKeys.aSelfieWithTheLicense.localize,
    ];
    return CustomScaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(30),
        child: HomeAppbar(),
      ),
      body: BlocBuilder<RideRegisterCubit, RideRegisterState>(
        builder: (context,state) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: BlocBuilder<RideRegisterCubit, RideRegisterState>(
                    builder: (context,state) {
                      var cubit = context.read<RideRegisterCubit>();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 32,left: 16,right: 16,),
                        child: Form(
                          key: cubit.driverLicenseFormKey,
                          child: Column(
                            spacing: 4,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // closeWidget(context),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Label(
                                    text: LocaleKeys.driversLicense.localize,
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

                              // Wrap(
                              //   direction: Axis.horizontal,
                              //   children: [
                              //     UploadFileWidget(
                              //       title: uploadFilesTitles[0],
                              //       onTap: (){
                              //           cubit.onUploadDriverLicensePicture(context);
                              //
                              //       },
                              //       imageUrl: state.driverLicensePicture,
                              //     ),
                              //     UploadFileWidget(
                              //       title: uploadFilesTitles[1],
                              //       onTap: (){
                              //           cubit.onUploadBackOfDriverLicensePicture(context);
                              //       },
                              //       imageUrl: state.backOfDriverLicensePicture,
                              //     ),
                              //     UploadFileWidget(
                              //       title: uploadFilesTitles[2],
                              //       onTap: (){
                              //           cubit.onUploadSelfieDriverLicensePicture(context);
                              //       },
                              //       imageUrl: state.selfieDriverLicensePicture,
                              //     )
                              //   ],
                              // ),

                              SizedBox(
                                height: MediaQuery.sizeOf(context).width*.4,
                                child: GridView.count(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  crossAxisCount: 3,
                                  childAspectRatio: 1 / 1.5,
                                  mainAxisSpacing: 32.w,
                                  crossAxisSpacing: 32.h,
                                  children: List.generate(
                                    state.isShipping==true?2:uploadFilesTitles.length,
                                    (index) => UploadFileWidget(
                                      title: state.isShipping==true?uploadLoadingFilesTitles[index]:uploadFilesTitles[index],
                                      onTap: (){
      ManageVibration.vibrate();
                                        if(index==0){
                                          cubit.onUploadDriverLicensePicture(context);
                                        }else if(index==1){
                                          cubit.onUploadBackOfDriverLicensePicture(context);
                                        }else{
                                          cubit.onUploadSelfieDriverLicensePicture(context);
                                        }
                                      },
                                      imageUrl: index==0?state.driverLicensePicture:index==1?state.backOfDriverLicensePicture:state.selfieDriverLicensePicture,
                                    ),
                                  ),
                                ),
                              ),
                              // const Sizer(),
                              // DefaultTextFormField(
                              //   currentController: cubit.rideDriverLicenseNumController,
                              //   fillColor: AppColors.GREYBG,
                              //   borderColor: Colors.transparent,
                              //   hint: LocaleKeys.licenseNumber.localize,
                              // ),
                              const Sizer(),
                              DatePickerTextField(color:context.isDarkMode?AppColors.GREY_DARK_COLOR:AppColors.GREYBG,initialDate: DateTime.now(), minDate: DateTime(1900), maxDate: DateTime(2090),onDateSelected: (date){
                                cubit.rideDriverExpireDateController.text = DateFormat('yyyy-MM-dd').format(date??DateTime.now());
                              }, controller:cubit.rideDriverExpireDateController,hintText: LocaleKeys.expireDate.localize,),
                            ],
                          ),
                        ),
                      );
                    }
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
      ManageVibration.vibrate();
                        print("object");
                        context.read<RideRegisterCubit>().onSubmitUploadingDriverLicense(context,params);
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
          );
        }
      ),
    );
  }
}