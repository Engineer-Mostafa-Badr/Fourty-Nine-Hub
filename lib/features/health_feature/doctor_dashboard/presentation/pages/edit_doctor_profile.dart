import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
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
import 'package:fourtyninehub/res/strings/labels.dart';
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
        appBar: const BackAppBar(
          label: Labels.editProfile,
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
            const UpdateDoctorTimetableCard(),
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
