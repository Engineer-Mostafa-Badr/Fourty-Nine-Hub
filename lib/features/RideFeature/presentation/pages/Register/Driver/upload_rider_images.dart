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

class UploadRiderImages extends StatelessWidget {
  const UploadRiderImages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RideCubit,RideState>(
        builder: (context,state) {
          return ListView(
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
              UploadImageRow(title: "ID",onTap: ()=>context.push(Routes.personalDocumentsScreen),disableUpload: state.isUploadDriverId!=null&&(state.isUploadDriverId==true),),
              const SizedBox(
                height: 40,
              ),
              UploadImageRow(title: "Driver License",onTap: ()=>context.push(Routes.driversLicenseScreen),disableUpload: state.isUploadDriverLicense!=null&&(state.isUploadDriverLicense==true),),
              const SizedBox(
                height: 40,
              ),
              UploadImageRow(title: "Car Image/License",onTap: ()=>context.push(Routes.vehicleInformationScreen),disableUpload: state.isUploadCarLicense!=null&&(state.isUploadCarLicense==true),),
              const SizedBox(
                height: 40,
              ),
              if(state.isUploadDrugAnalysis!=null&&state.isUploadDrugAnalysis==true)...[UploadImageRow(title: "Drag analysis",onTap: ()=>context.push(Routes.drugAnalysisScreen),disableUpload: state.isUploadDrugAnalysis!=null&&(state.isUploadDrugAnalysis==true),),
              const SizedBox(
                height: 40,
              )],
              if(state.isUploadCriminalRecord!=null&&state.isUploadCriminalRecord==true)...[UploadImageRow(title: "Criminal Record",onTap: ()=>context.push(Routes.criminalRecordScreen),disableUpload: state.isUploadCriminalRecord!=null&&(state.isUploadCriminalRecord==true),),const SizedBox(
                height: 40,
              )],
              if(state.isUploadTechnicalExamination!=null&&state.isUploadTechnicalExamination==true)UploadImageRow(title: "Terminal Examination",onTap: ()=>context.push(Routes.technicalExaminationScreen),disableUpload: state.isUploadTechnicalExamination!=null&&(state.isUploadTechnicalExamination==true),),
            ],
          );
        }
      ),
    );
  }
}
