import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateDoctorProfilePhotoPicker extends StatefulWidget {
  const CreateDoctorProfilePhotoPicker({super.key});

  @override
  State<CreateDoctorProfilePhotoPicker> createState() =>
      _CreateDoctorProfilePhotoPickerState();
}

class _CreateDoctorProfilePhotoPickerState
    extends State<CreateDoctorProfilePhotoPicker> {
  @override
  Widget build(BuildContext context) {
    final createDoctorCubit = context.read<CreateDoctorCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: context.isArabic ? 'الصورة الشخصية' : 'Profile Photo',
          style: Styles.headerText(),
        ),
        const Sizer(),
        BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
            buildWhen: (previous, current) =>
                current is CreateDoctorUploadProfileImage ||
                current is CreateDoctorInitial,
            builder: (context, state) {
              if (state is CreateDoctorUploadProfileImage) {
                return Wrap(runSpacing: 10, spacing: 10, children: [
                  ImagePickerPlaceholder(
                    image: Image.file(
                      File(state.file.path),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await createDoctorCubit.uploadProfileImage(context: context);
                    },
                    child: BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
                        builder: (context, state) {
                      return ImagePickerPlaceholder(
                        borderColor: Colors.grey,
                        title:
                            context.isArabic ? 'تغيير الصورة' : 'Change Photo',
                      );
                    }),
                  )
                ]);
              }
              return InkWell(
                onTap: () async {
                  await createDoctorCubit.uploadProfileImage(context: context);
                },
                child: BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
                    builder: (context, state) {
                  return ImagePickerPlaceholder(
                    borderColor: Colors.grey,
                    title: context.isArabic ? 'اختر صورة' : 'Choose Photo',
                  );
                }),
              );
            })
      ],
    );
  }
}
