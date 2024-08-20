import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:image_picker/image_picker.dart';

class CreateDoctorLicensePhotoPicker extends StatelessWidget {
  const CreateDoctorLicensePhotoPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final createDoctorCubit = context.read<CreateDoctorCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: "License",
          style: Styles.headerText(),
        ),
        const Sizer(),
        Row(
          children: [
            InkWell(
              onTap: () async {
                await createDoctorCubit.uploadPracticingFrontImage();
              },
              child: BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
                buildWhen: (previous, current) =>
                    current is CreateDoctorUploadPracticingFrontImage ||
                    current is CreateDoctorInitial,
                builder: (context, state) {
                  if (state is CreateDoctorUploadPracticingFrontImage) {
                    return ImagePickerPlaceholder(
                      image: XFile(state.file.path),
                    );
                  }
                  return const ImagePickerPlaceholder(
                    title: 'Front',
                  );
                },
              ),
            ),
            const Sizer(),
            InkWell(
              onTap: () async {
                await createDoctorCubit.uploadPracticingBehindImage();
              },
              child: BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
                buildWhen: (previous, current) =>
                    current is CreateDoctorUploadPracticingBehindImage ||
                    current is CreateDoctorInitial,
                builder: (context, state) {
                  if (state is CreateDoctorUploadPracticingBehindImage) {
                    return ImagePickerPlaceholder(
                      image: XFile(state.file.path),
                    );
                  }
                  return const ImagePickerPlaceholder(
                    title: 'Behind',
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
