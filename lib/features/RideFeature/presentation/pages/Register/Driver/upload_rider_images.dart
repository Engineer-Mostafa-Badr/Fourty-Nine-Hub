import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/ride_register/ride_register_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/Driver/creminal_record_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/Driver/drivers_license_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/Driver/drug_analysis.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/Driver/personal_documents_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/Driver/personal_information_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/Driver/technical_examination_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/Register/Driver/vehicle_information_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/upload_image_row.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

class UploadRiderImagesParams{
  final bool? isShipping;
  final bool? isSocket;

  UploadRiderImagesParams({required this.isShipping, required this.isSocket});

}
class UploadRiderImages extends StatefulWidget {
  const UploadRiderImages({super.key, this.params});
  final UploadRiderImagesParams? params;
  @override
  State<UploadRiderImages> createState() => _UploadRiderImagesState();
}

class _UploadRiderImagesState extends State<UploadRiderImages> {

  @override
  void initState() {
    context.read<RideRegisterCubit>().fetchRideUploadedImagesData(context,widget.params);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (c,v)=>context.push(Routes.RIDE_HOME),
      child: RefreshIndicator(
        onRefresh: ()=>context.read<RideRegisterCubit>().fetchRideUploadedImagesData(context,widget.params),
        child: Scaffold(
          body: BlocBuilder<RideRegisterCubit,RideRegisterState>(
            builder: (context,state) {
              var cubit = context.read<RideRegisterCubit>();
              return state.isLoading?const Center(child: CustomCircularProgressIndicator()):ListView(
                padding: const EdgeInsets.only(top: 82, left: 16, right: 16),
                children: [
                  Label(
                    text: LocaleKeys.completeRegistration.localize,
                    style: Styles.headerText(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  state.isShipping==true?loadingUploadImages(cubit,state,widget.params!):rideUploadImages(state,widget.params!),
                  // UploadImageRow(title: "ID",onTap: ()=>context.push(Routes.personalDocumentsScreen),disableUpload: state.isUploadDriverId!=null&&(state.isUploadDriverId==true),),
                  // const SizedBox(
                  //   height: 40,
                  // ),
                  // UploadImageRow(title: "Driver License",onTap: ()=>context.push(Routes.driversLicenseScreen),disableUpload: state.isUploadDriverLicense!=null&&(state.isUploadDriverLicense==true),),
                  // const SizedBox(
                  //   height: 40,
                  // ),
                  // UploadImageRow(title: "Car Image/License",onTap: ()=>context.push(Routes.vehicleInformationScreen),disableUpload: state.isUploadCarLicense!=null&&(state.isUploadCarLicense==true),),
                  // const SizedBox(
                  //   height: 40,
                  // ),
                  // if(state.pictureOptional!=null&&state.pictureOptional?.openDrugAnalysis==true&&state.registerType=='socket')...[UploadImageRow(title: "Drag analysis",onTap: ()=>context.push(Routes.drugAnalysisScreen),disableUpload: state.isUploadDrugAnalysis!=null&&(state.isUploadDrugAnalysis==true),),
                  // const SizedBox(
                  //   height: 40,
                  // )],
                  // if(state.pictureOptional!=null&&state.pictureOptional?.openCriminalRecord==true&&state.registerType=='socket')...[UploadImageRow(title: "Criminal Record",onTap: ()=>context.push(Routes.criminalRecordScreen),disableUpload: state.isUploadCriminalRecord!=null&&(state.isUploadCriminalRecord==true),),const SizedBox(
                  //   height: 40,
                  // )],
                  // if(state.pictureOptional!=null&&state.pictureOptional?.openTechnicalExamination==true&&state.registerType=='socket')UploadImageRow(title: "Terminal Examination",onTap: ()=>context.push(Routes.technicalExaminationScreen),disableUpload: state.isUploadTechnicalExamination!=null&&(state.isUploadTechnicalExamination==true),),
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  Widget rideUploadImages(RideRegisterState state,UploadRiderImagesParams params){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        UploadImageRow(title: LocaleKeys.personalDocuments.localize,onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider.value(
              value: serviceLocator<RideRegisterCubit>(),
              child: PersonalDocumentsScreen(params: params,))));
          params.isShipping==true?context.read<RideRegisterCubit>().fetchLoaderInfo(context,false):context.read<RideRegisterCubit>().fetchRideDriverInfo(context,false);
          // context.push(Routes.personalDocumentsScreen);
        },disableUpload: (state.driverInfo?.isUploadDriverId==true),),
        const SizedBox(
          height: 40,
        ),
        UploadImageRow(title: LocaleKeys.driversLicense.localize,onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider.value(
              value: serviceLocator<RideRegisterCubit>(),
              child: DriversLicenseScreen(params: params,))));
          params.isShipping==true?context.read<RideRegisterCubit>().fetchLoaderInfo(context,false):context.read<RideRegisterCubit>().fetchRideDriverInfo(context,false);
          // context.push(Routes.driversLicenseScreen);
        },disableUpload: (state.driverInfo?.isUploadDriverLicense==true),),
        const SizedBox(
          height: 40,
        ),
        UploadImageRow(title: LocaleKeys.vehicleInformation.localize,onTap: () async {
          await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider.value(
              value: serviceLocator<RideRegisterCubit>(),
              child: VehicleInformationScreen(params: params,))));
          params.isShipping==true?context.read<RideRegisterCubit>().fetchLoaderInfo(context,false):context.read<RideRegisterCubit>().fetchRideDriverInfo(context,false);
          // context.push(Routes.vehicleInformationScreen);
        },disableUpload: (state.driverInfo?.isUploadCarLicense==true&&state.driverInfo?.isUploadCarImage==true),),
        const SizedBox(
          height: 40,
        ),
        if(state.pictureOptional!=null&&state.pictureOptional?.openCriminalRecord==true&&state.registerType=='socket')...[UploadImageRow(title: LocaleKeys.criminalRecord.localize,onTap: () async {
          // context.push(Routes.criminalRecordScreen);
          await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider.value(
              value: serviceLocator<RideRegisterCubit>(),
              child: const CriminalRecordScreen())));
          params.isShipping==true?context.read<RideRegisterCubit>().fetchLoaderInfo(context,false):context.read<RideRegisterCubit>().fetchRideDriverInfo(context,false);
        },disableUpload: (state.isUploadCriminalRecord==true),),const SizedBox(
          height: 40,
        )],
        if(state.pictureOptional!=null&&state.pictureOptional?.openDrugAnalysis==true&&state.registerType=='socket')...[UploadImageRow(title: LocaleKeys.dragAnalysis.localize,onTap: () async {
          // context.push(Routes.drugAnalysisScreen);
          await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider.value(
              value: serviceLocator<RideRegisterCubit>(),
              child: const DragAnalyticsScreen())));
          params.isShipping==true?context.read<RideRegisterCubit>().fetchLoaderInfo(context,false):context.read<RideRegisterCubit>().fetchRideDriverInfo(context,false);
        },disableUpload: (state.isUploadDrugAnalysis==true),),
          if(state.pictureOptional?.drugAnalysisPhone.isNotEmpty??false)...[const SizedBox(height: 10,),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "${LocaleKeys.phone.localize} : ",
                    style:
                    Styles.headerText(
                        color: AppColors.SECONDARY_COLOR)),
                TextSpan(
                    text: state.pictureOptional?.drugAnalysisPhone??'',
                    style: Styles.mediumText(
                      color: context.isDarkMode?Colors.white:AppColors.SECONDARY_COLOR
                    ))
              ]),
            ),
            ],
          if(state.pictureOptional?.drugAnalysisAddress.isNotEmpty??false)...[const SizedBox(height: 10,),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "${LocaleKeys.address.localize} : ",
                    style:
                    Styles.headerText(
                        color: AppColors.SECONDARY_COLOR)),
                TextSpan(
                    text: state.pictureOptional?.drugAnalysisAddress??'',
                    style: Styles.mediumText(
                        color: context.isDarkMode?Colors.white:AppColors.SECONDARY_COLOR
                    ))
              ]),
            ),
          ],
          const SizedBox(
            height: 40,
          )],
        if(state.pictureOptional!=null&&state.pictureOptional?.openTechnicalExamination==true&&state.registerType=='socket')...[
          UploadImageRow(title: LocaleKeys.technicalExamination.localize,onTap: () async {
            // context.push(Routes.technicalExaminationScreen);
            await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider.value(
                value: serviceLocator<RideRegisterCubit>(),
                child: const TechnicalExaminationScreen())));
            params.isShipping==true?context.read<RideRegisterCubit>().fetchLoaderInfo(context,false):context.read<RideRegisterCubit>().fetchRideDriverInfo(context,false);
          },disableUpload:(state.isUploadTechnicalExamination==true),),
          if(state.pictureOptional?.technicalExaminationPhone.isNotEmpty??false)...[const SizedBox(height: 10,),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "${LocaleKeys.phone.localize} : ",
                    style:
                    Styles.headerText(
                        color: AppColors.SECONDARY_COLOR)),
                TextSpan(
                    text: state.pictureOptional?.technicalExaminationPhone??'',
                    style: Styles.mediumText(
                        color: context.isDarkMode?Colors.white:AppColors.SECONDARY_COLOR
                    ))
              ]),
            ),
          ],
          if(state.pictureOptional?.technicalExaminationAddress.isNotEmpty??false)...[const SizedBox(height: 10,),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "${LocaleKeys.address.localize} : ",
                    style:
                    Styles.headerText(
                        color: AppColors.SECONDARY_COLOR)),
                TextSpan(
                    text: state.pictureOptional?.technicalExaminationAddress??'',
                    style: Styles.mediumText(
                        color: context.isDarkMode?Colors.white:AppColors.SECONDARY_COLOR

                    ))
              ]),
            ),
            ],

        ]
      ]
    );
  }
  Widget loadingUploadImages(RideRegisterCubit cubit,RideRegisterState state,UploadRiderImagesParams params){
    return Column(
      children:[
        UploadImageRow(title: LocaleKeys.personalDocuments.localize,onTap: () async {
         await  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider.value(
              value: serviceLocator<RideRegisterCubit>(),
              child: PersonalDocumentsScreen(params: params,))));
         params.isShipping==true?context.read<RideRegisterCubit>().fetchLoaderInfo(context,false):context.read<RideRegisterCubit>().fetchRideDriverInfo(context,false);
          // context.push(Routes.personalDocumentsScreen);
        },disableUpload: state.loaderInfo?.isUploadDriverId==true,),
        const SizedBox(
          height: 40,
        ),
        UploadImageRow(title: LocaleKeys.driversLicense.localize,onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider.value(
              value: serviceLocator<RideRegisterCubit>(),
              child: DriversLicenseScreen(params: params,))));
        params.isShipping==true?context.read<RideRegisterCubit>().fetchLoaderInfo(context,false):context.read<RideRegisterCubit>().fetchRideDriverInfo(context,false);
          // context.push(Routes.driversLicenseScreen);
        },disableUpload: state.loaderInfo?.isUploadDriverLicense==true,),
        const SizedBox(
          height: 40,
        ),
        UploadImageRow(title: LocaleKeys.vehicleInformation.localize,onTap: () async {
          // context.push(Routes.vehicleInformationScreen);
          await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider.value(
              value: serviceLocator<RideRegisterCubit>(),
              child: VehicleInformationScreen(params: params,))));
          params.isShipping==true?context.read<RideRegisterCubit>().fetchLoaderInfo(context,false):context.read<RideRegisterCubit>().fetchRideDriverInfo(context,false);
        },disableUpload: state.loaderInfo?.isUploadCarLicense==true&&state.loaderInfo?.isUploadCarImage==true,),
      ]
    );
  }
}
