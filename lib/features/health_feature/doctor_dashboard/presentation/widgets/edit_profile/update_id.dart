import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_id_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_profile/edit_doctor_profile_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/pages/edit_doctor_docs.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_profile/update_card.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:go_router/go_router.dart';

class UpdateDoctorIdCard extends StatelessWidget {
  const UpdateDoctorIdCard({super.key, required this.subCategoryId});
  final String subCategoryId;
  @override
  Widget build(BuildContext context) {
    return EditDoctorProfileCard(
      title: LocaleKeys.id.localize,
      onTap: () {
        bottomSheet(
          context: context,
          widget: EditDoctorDocsView(
            onSubmit: (DoctorDocsParams doctorDocsParams) async{
              bool result =await context.read<EditDoctorProfileCubit>().updateID(doctorDocsParams);
              if(result == true){
                context.pop();
                Future.delayed(const Duration(milliseconds: 500),(){
                  showSuccessMessage(context, 'Your request send successfully and waiting for approving');
                });
              }
            }, subCategoryId: subCategoryId, from: 'id',
          ),
        );
      },
    );
  }
}
