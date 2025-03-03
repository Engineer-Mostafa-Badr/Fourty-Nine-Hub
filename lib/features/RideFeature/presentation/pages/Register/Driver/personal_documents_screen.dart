import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:go_router/go_router.dart';

import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import '../widgets/close_widget.dart';
import '../widgets/register_floating_action_button.dart';
import '../widgets/upload_file_widget.dart';

class PersonalDocumentsScreen extends StatelessWidget {
  const PersonalDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> uploadFilesTitles = [
      LocaleKeys.nationalIdCard.localize,
      LocaleKeys.backOfTheId.localize,
      LocaleKeys.criminalRecord.localize,
      LocaleKeys.drugAnalysis.localize,
    ];
    return CustomScaffold(
      appBar: const HomeAppbar(),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32,left: 16,right: 16,),
                child: BlocBuilder<RideCubit, RideState>(
                  builder: (context,state) {
                    var cubit = context.read<RideCubit>();
                    return Column(
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        closeWidget(context),
                        Label(
                          text: LocaleKeys.personalDocuments.localize,
                          style: Styles.headerText(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Sizer(),
                        // Wrap(
                        //   direction: Axis.horizontal,
                        //   children: [
                        //     UploadFileWidget(
                        //       title: uploadFilesTitles[0],
                        //       onTap: (){
                        //         cubit.onUploadPersonalFrontIdPicture(context);
                        //       },
                        //       imageUrl: state.driverLicensePicture,
                        //     ),
                        //     UploadFileWidget(
                        //       title: uploadFilesTitles[1],
                        //       onTap: (){
                        //         cubit.onUploadPersonalBackIdPicture(context);
                        //       },
                        //       imageUrl: state.backOfDriverLicensePicture,
                        //     ),
                        //     UploadFileWidget(
                        //       title: uploadFilesTitles[2],
                        //       onTap: (){
                        //         cubit.onUploadPersonalCriminalRecordPicture(context);
                        //       },
                        //       imageUrl: state.selfieDriverLicensePicture,
                        //     ),
                        //     UploadFileWidget(
                        //       title: uploadFilesTitles[3],
                        //       onTap: (){
                        //         cubit.onUploadPersonalDrugAnalysisPicture(context);
                        //       },
                        //       imageUrl: state.selfieDriverLicensePicture,
                        //     )
                        //   ],
                        // ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).width*.7,
                          child: GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            crossAxisCount: 3,
                            childAspectRatio: .85,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            children: List.generate(
                              uploadFilesTitles.length,
                              (index) => UploadFileWidget(
                                title: uploadFilesTitles[index],
                                onTap: (){
                                  if(index==0){
                                    cubit.onUploadPersonalFrontIdPicture(context);
                                  }else if(index==1){
                                    cubit.onUploadPersonalBackIdPicture(context);
                                  }else if(index==2){
                                    cubit.onUploadPersonalCriminalRecordPicture(context);
                                  }else{
                                    cubit.onUploadPersonalDrugAnalysisPicture(context);
                                  }
                                },
                                imageUrl: index==0?state.personalFrontIdPicture:index==1?state.personalBackIdPicture:index==2?state.personalCriminalRecordPicture:state.personalDrugAnalysisPicture,

                              ),
                            ),
                          ),
                        ),
                        const Sizer(),
                        DefaultTextFormField(
                          currentController: cubit.ridePersonalDocLicenseNumController,
                          fillColor: AppColors.GREYBG,
                          borderColor: Colors.transparent,
                          hint: LocaleKeys.licenseNumber.localize,
                        ),
                        const Sizer(),
                        DefaultTextFormField(
                          currentController: cubit.ridePersonalDocExpireDateController,
                          fillColor: AppColors.GREYBG,
                          borderColor: Colors.transparent,
                          hint: LocaleKeys.expireDate.localize,
                        ),
                        const Sizer(),
                        DefaultTextFormField(
                          currentController: cubit.rideDragAnalysisExpireDateController,
                          fillColor: AppColors.GREYBG,
                          borderColor: Colors.transparent,
                          hint: '${LocaleKeys.drugAnalysis.localize} ${LocaleKeys.expireDate.localize}',
                        ),
                        const Sizer(),
                        DefaultTextFormField(
                          currentController: cubit.rideCriminalRecordExpireDateController,
                          fillColor: AppColors.GREYBG,
                          borderColor: Colors.transparent,
                          hint: '${LocaleKeys.criminalRecord.localize} ${LocaleKeys.expireDate.localize}',
                        ),
                      ],
                    );
                  }
                ),
              ),
            ),
          ),
          RegisterNextRow(
            index: 3,
            onTap: () => context.push(Routes.vehicleInformationScreen),
          ),
        ],
      ),
    );
  }
}
