import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateDoctorIDPhotoPicker extends StatelessWidget {
  const CreateDoctorIDPhotoPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final createDoctorCubit = context.read<CreateDoctorCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: "ID",
          style: Styles.headerText(),
        ),
        const Sizer(),
        Row(
          children: [
            InkWell(
              onTap: () async {
                await createDoctorCubit.uploadIdFrontImage();
              },
              child: BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
                buildWhen: (previous, current) =>
                    current is CreateDoctorUploadIdFrontImage ||
                    current is CreateDoctorInitial,
                builder: (context, state) {
                  if (state is CreateDoctorUploadIdFrontImage) {
                    return ImagePickerPlaceholder(
                      image: state.file,
                    );
                  }
                  return const ImagePickerPlaceholder(
                    tilte: 'Front',
                  );
                },
              ),
            ),
            const Sizer(),
            InkWell(
              onTap: () async {
                await createDoctorCubit.uploadIdBehindImage();
              },
              child: BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
                buildWhen: (previous, current) =>
                    current is CreateDoctorUploadIdBehindImage ||
                    current is CreateDoctorInitial,
                builder: (context, state) {
                  if (state is CreateDoctorUploadIdBehindImage) {
                    return ImagePickerPlaceholder(
                      image: state.file,
                    );
                  }
                  return const ImagePickerPlaceholder(
                    tilte: 'Back',
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
