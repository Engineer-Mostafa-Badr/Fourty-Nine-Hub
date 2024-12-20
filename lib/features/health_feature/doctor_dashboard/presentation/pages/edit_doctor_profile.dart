import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_time_table/time_table_options_checkbox.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_profile/edit_doctor_profile_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_profile/delete_account.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_profile/update_id.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_profile/update_personal.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_profile/update_practicing.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_profile/update_profile_photo_card.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_profile/update_time_table.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class EditDoctorProfileView extends StatelessWidget {
  const EditDoctorProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditDoctorProfileCubit, EditDoctorProfileState>(
      listener: (context, state) {
        switch (state.status) {
          case EditDoctorProfileStateStatus.startLoading:
            showLoadingDialog(context);
            break;
          case EditDoctorProfileStateStatus.endLoading:
            context.pop();
            break;
          case EditDoctorProfileStateStatus.error:
            showErrorMessage(
              context,
              getFailureMessage(
                state.failure ?? UnknownFailure(''),
                context,
              ),
            );
            break;
          case EditDoctorProfileStateStatus.doctorDeleted:
            context.go(Routes.VISITA);
            break;
          default:
            break;
        }
      },
      builder: (context, state)=>Scaffold(
        appBar: BackAppBar(
          label: LocaleKeys.editProfile.localize,
        ),
        body: state.status==EditDoctorProfileStateStatus.initial?const Center(child: CircularProgressIndicator()):ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const UpdateProfilePhotoCard(),
            const Sizer(),
            UpdateDoctorIdCard(subCategoryId: state.doctor?.subCategory.id??'',),
            const Sizer(),
            UpdateDoctorPracticingCirtificateCard(subCategoryId: state.doctor?.subCategory.id??'',),
            const Sizer(),
            UpdateDoctorTimetableCard(params: CheckBoxParams(showCall: state.doctor?.calls??false,showHomeVisit: state.doctor?.visitHome??false,showClinic: state.doctor?.clinic??false),),
            const Sizer(),
            UpdateDoctorPersonalInfo(doctor: state.doctor!,),
            const Sizer(),
            const DeleteDoctorAccountCard(),
          ],
        ),
      ),
    );
  }
}
