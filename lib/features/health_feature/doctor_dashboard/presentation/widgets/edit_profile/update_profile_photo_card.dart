import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_uploader_widget.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_profile/edit_doctor_profile_cubit.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

class UpdateProfilePhotoCard extends StatelessWidget {
  const UpdateProfilePhotoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditDoctorProfileCubit, EditDoctorProfileState>(
      buildWhen: (previous, current) =>
          current.status == EditDoctorProfileStateStatus.getDoctor ||
          current.status == EditDoctorProfileStateStatus.initial,
      builder: (context, state) {
        if (state.doctor != null) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: [
                ImageUploaderWidget(
                  subCategoryId: state.doctor?.subCategory.id ?? '',
                  image: Image.network(state.doctor?.image ?? ''),
                  onUploaded: (data) {
                    context
                        .read<EditDoctorProfileCubit>()
                        .updateProfilePhoto(data.mediaId);
                  },
                ),
                const Sizer(
                  height: 20,
                ),
                AppButton(
                  label: Labels.update,
                  onPressed: () {},
                ),
              ],
            ),
          );
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: [
                const ImagePickerPlaceholder(tilte: 'Profile'),
                const Sizer(
                  height: 20,
                ),
                AppButton(
                  label: Labels.update,
                  onPressed: () {},
                ),
              ],
            ),
          );
        }
      },
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: [
          ImageUploaderWidget(
            subCategoryId: '',
          ),
          const Sizer(
            height: 20,
          ),
          AppButton(
            label: Labels.update,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
