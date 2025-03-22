import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/upload_image_row.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

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
    context.read<RideCubit>().fetchRideUploadedImagesData(context,widget.params);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RideCubit,RideState>(
        builder: (context,state) {
          print("state.loaderInfo?.toJson()${state.loaderInfo?.toJson()}");
          print("objectstate.registerType${state.registerType}");
          print("objectstate.registerType${state.isUploadDrugAnalysis}");
          print("objectstate.registerType${state.isUploadCriminalRecord}");
          print("objectstate.registerType${state.isUploadTechnicalExamination}");
          return state.isLoading?const Center(child: CircularProgressIndicator()):ListView(
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
              state.isShipping==true?loadingUploadImages(state):rideUploadImages(state),
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
    );
  }

  Widget rideUploadImages(RideState state){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        UploadImageRow(title: "ID",onTap: ()=>context.push(Routes.personalDocumentsScreen),disableUpload: (state.driverInfo?.isUploadDriverId==true),),
        const SizedBox(
          height: 40,
        ),
        UploadImageRow(title: "Driver License",onTap: ()=>context.push(Routes.driversLicenseScreen),disableUpload: (state.driverInfo?.isUploadDriverLicense==true),),
        const SizedBox(
          height: 40,
        ),
        UploadImageRow(title: "Car Image/License",onTap: ()=>context.push(Routes.vehicleInformationScreen),disableUpload: (state.driverInfo?.isUploadCarLicense==true),),
        const SizedBox(
          height: 40,
        ),
        if(state.pictureOptional!=null&&state.pictureOptional?.openCriminalRecord==true&&state.registerType=='socket')...[UploadImageRow(title: "Criminal Record",onTap: ()=>context.push(Routes.criminalRecordScreen),disableUpload: (state.isUploadCriminalRecord==true),),const SizedBox(
          height: 40,
        )],
        if(state.pictureOptional!=null&&state.pictureOptional?.openDrugAnalysis==true&&state.registerType=='socket')...[UploadImageRow(title: "Drag analysis",onTap: ()=>context.push(Routes.drugAnalysisScreen),disableUpload: (state.isUploadDrugAnalysis==true),),
          if(state.pictureOptional?.drugAnalysisAddress.isNotEmpty??false)...[const SizedBox(height: 10,),Label(
            text: "${LocaleKeys.address.localize} ${state.pictureOptional?.drugAnalysisAddress??''}",
            style: Styles.headerText(
              fontWeight: FontWeight.w500,
            ),
          ),],
          if(state.pictureOptional?.drugAnalysisPhone.isNotEmpty??false)...[const SizedBox(height: 10,),Label(
            text: "${LocaleKeys.phone.localize} ${state.pictureOptional?.drugAnalysisPhone??''}",
            style: Styles.headerText(
              fontWeight: FontWeight.w500,
            ),
          )],
          const SizedBox(
            height: 40,
          )],
        if(state.pictureOptional!=null&&state.pictureOptional?.openTechnicalExamination==true&&state.registerType=='socket')...[
          UploadImageRow(title: LocaleKeys.technicalExamination.localize,onTap: ()=>context.push(Routes.technicalExaminationScreen),disableUpload:(state.isUploadTechnicalExamination==true),),
          if(state.pictureOptional?.technicalExaminationAddress.isNotEmpty??false)...[const SizedBox(height: 10,),Label(
            text: "${LocaleKeys.address.localize} ${state.pictureOptional?.technicalExaminationAddress??''}",
            style: Styles.headerText(
              fontWeight: FontWeight.w500,
            ),
          )],
          if(state.pictureOptional?.technicalExaminationPhone.isNotEmpty??false)...[const SizedBox(height: 10,),Label(
            text: "${LocaleKeys.phone.localize} ${state.pictureOptional?.technicalExaminationPhone??''}",
            style: Styles.headerText(
              fontWeight: FontWeight.w500,
            ),
          )],
        ]
      ]
    );
  }
  Widget loadingUploadImages(RideState state){
    return Column(
      children:[
        UploadImageRow(title: "ID",onTap: () {
          context.push(Routes.personalDocumentsScreen);
        },disableUpload: state.loaderInfo?.isUploadDriverId==true,),
        const SizedBox(
          height: 40,
        ),
        UploadImageRow(title: "Driver License",onTap: ()=>context.push(Routes.driversLicenseScreen),disableUpload: state.loaderInfo?.isUploadDriverLicense==true,),
        const SizedBox(
          height: 40,
        ),
        UploadImageRow(title: "Car Image/License",onTap: ()=>context.push(Routes.vehicleInformationScreen),disableUpload: state.loaderInfo?.isUploadCarLicense==true&&state.loaderInfo?.isUploadCarImage==true,),
      ]
    );
  }
}
