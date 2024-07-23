import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:image_picker/image_picker.dart';

class CreateDoctorProfilePhotoPicker extends StatefulWidget {
  const CreateDoctorProfilePhotoPicker({super.key});

  @override
  State<CreateDoctorProfilePhotoPicker> createState() =>
      _CreateDoctorProfilePhotoPickerState();
}

class _CreateDoctorProfilePhotoPickerState
    extends State<CreateDoctorProfilePhotoPicker> {
  XFile? image;

  @override
  Widget build(BuildContext context) {
    final createDoctorCubit = context.read<CreateDoctorCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: "Photo",
          style: Styles.headerText(),
        ),
        const Sizer(),
        InkWell(
          onTap: () async {
            image = await createDoctorCubit.uploadProfileImage();
          },
          child: ImagePickerPlaceholder(
            image: image,
          ),
        ),
      ],
    );
  }
}
