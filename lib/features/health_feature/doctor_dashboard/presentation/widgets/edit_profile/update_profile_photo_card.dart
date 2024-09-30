import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_uploader_widget.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_profile/edit_doctor_profile_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateProfilePhotoCard extends StatelessWidget {
  const UpdateProfilePhotoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: [
          BlocBuilder<EditDoctorProfileCubit, EditDoctorProfileState>(
              buildWhen: (previous, current) =>
                  current.status == EditDoctorProfileStateStatus.getDoctor ||
                  current.status == EditDoctorProfileStateStatus.initial,
              builder: (context, state) {
                if (state.doctor != null) {
                  return ImageUploaderWidget(
                    subCategoryId: state.doctor?.subCategory.id ?? '',
                    image: Image.network(state.doctor?.image ?? ''),
                    width: 100,
                    onUploaded: (data) {
                      context
                          .read<EditDoctorProfileCubit>()
                          .updateProfilePhoto(data.mediaId);
                    },
                  );
                } else {
                  return const ImagePickerPlaceholder(tilte: 'Profile');
                }
              }),
        ],
      ),
    );
  }
}
