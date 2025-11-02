import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateful/picker/date_picker_field.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/ride_register/ride_register_cubit.dart';
import 'package:go_router/go_router.dart';

import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:intl/intl.dart';
import '../widgets/upload_file_widget.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class TechnicalExaminationScreen extends StatelessWidget {
  const TechnicalExaminationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      enableCustomAppBar: true,
      appBar: BackAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: BlocBuilder<RideRegisterCubit, RideRegisterState>(
                builder: (context,state) {
                  var cubit = context.read<RideRegisterCubit>();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 32,left: 16,right: 16,),
                    child: Form(
                      key: cubit.terminalExaminationFormKey,
                      child: Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // closeWidget(context),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Label(
                                text: LocaleKeys.technicalExamination.localize,
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

                          UploadFileWidget(
                            title: LocaleKeys.technicalExamination.localize,
                            onTap: (){
      ManageVibration.vibrate();
                              cubit.onUploadPersonalTechnicalExaminationPicture(context);

                            },
                            imageUrl:state.personalTechnicalExaminationPicture,
                          ),
                          // const Sizer(),
                          // DefaultTextFormField(
                          //   currentController: cubit.rideDriverLicenseNumController,
                          //   fillColor: AppColors.GREYBG,
                          //   borderColor: Colors.transparent,
                          //   hint: LocaleKeys.licenseNumber.localize,
                          // ),
                          const Sizer(),
                          DatePickerTextField(color:context.isDarkMode?AppColors.GREY_DARK_COLOR:AppColors.GREYBG,initialDate: DateTime.now(),
                            minDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day+7),
                            maxDate: DateTime(2090),
                            pickerTitle: context.isArabic?'تاريخ انتهاء الصلاحية':'Expire Date',
                            onDateSelected: (date){
                            cubit.rideTechnicalExaminationExpireDateController.text = DateFormat('yyyy-MM-dd',context.isArabic?'ar':'en').format(date??DateTime.now());
                          }, controller:cubit.rideTechnicalExaminationExpireDateController,hintText: LocaleKeys.expireDate.localize,),
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
                    if(context.read<RideRegisterCubit>().state.personalTechnicalExaminationPicture==null){
                      showErrorMessage(context, "Please select technical examination");
                    }else{
                      context.read<RideRegisterCubit>().onSubmitUploadingTechnicalExamination(context);
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
}