import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

import '../widgets/upload_file_widget.dart';

class DragAnalyticsScreen extends StatelessWidget {
  const DragAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> uploadFilesTitles = [
      LocaleKeys.driversLicense.localize,
      LocaleKeys.backOfTheLicense.localize,
      LocaleKeys.aSelfieWithTheLicense.localize,
    ];
    return CustomScaffold(
      appBar: const HomeAppbar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: BlocBuilder<RideCubit, RideState>(
                builder: (context,state) {
                  var cubit = context.read<RideCubit>();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 32,left: 16,right: 16,),
                    child: Form(
                      key: cubit.drugAnalysisFormKey,
                      child: Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // closeWidget(context),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Label(
                                text: LocaleKeys.dragAnalysis.localize,
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
                            title: LocaleKeys.dragAnalysis.localize,
                            onTap: (){
                              cubit.onUploadPersonalDrugAnalysisPicture(context);

                            },
                            imageUrl:state.personalDrugAnalysisPicture,
                          ),
                          // const Sizer(),
                          // DefaultTextFormField(
                          //   currentController: cubit.rideDriverLicenseNumController,
                          //   fillColor: AppColors.GREYBG,
                          //   borderColor: Colors.transparent,
                          //   hint: LocaleKeys.licenseNumber.localize,
                          // ),
                          const Sizer(),
                          DefaultTextFormField(
                            currentController: cubit.rideDragAnalysisExpireDateController,
                            fillColor: AppColors.GREYBG,
                            borderColor: Colors.transparent,
                            hint: LocaleKeys.expireDate.localize,
                            validator: (value){
                              if(value!=null && value.isEmpty){
                                return LocaleKeys.required.localize;
                              }
                              return null;
                            },
                          ),
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
                    if(context.read<RideCubit>().state.personalDrugAnalysisPicture==null){
                      showErrorMessage(context, "Please select drag analysis");
                    }else{
                      context.read<RideCubit>().onSubmitUploadingDrugAnalysis(context);
                    }                  },
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
