import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/custom_image_picker_health.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateDoctorLicensePhotoPicker extends StatelessWidget {
  const CreateDoctorLicensePhotoPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final createDoctorCubit = context.read<CreateDoctorCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: LocaleKeys.licenseFrontAndBack.localize,
          style: Styles.headerText(height: 1.60),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Column(
              children: [
                // BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
                //   buildWhen: (previous, current) =>
                //       current is CreateDoctorUploadPracticingFrontImage ||
                //       current is CreateDoctorInitial,
                //   builder: (context, state) {
                //     return CustomImagePickerHealth(
                //       isUploaded:
                //           state is CreateDoctorUploadPracticingFrontImage,
                //       onTap: () async {
                //         await createDoctorCubit.uploadPracticingFrontImage(
                //             context: context);
                //       },
                //     );
                //     // if (state is CreateDoctorUploadPracticingFrontImage) {
                //     //   return ImagePickerPlaceholder(
                //     //     image: Image.file(
                //     //       File(state.file.path),
                //     //     ),
                //     //   );
                //     // }
                //     // return ImagePickerPlaceholder(
                //     //   title: context.isArabic ? 'الوجه' : 'Front',
                //     // );
                //   },
                // ),
                BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
                  buildWhen: (previous, current) =>
                  current is CreateDoctorUploadPracticingFrontImage ||
                      current is CreateDoctorInitial,
                  builder: (context, state) {
                    return CustomImagePickerHealth(
                      isUploaded: state is CreateDoctorUploadPracticingFrontImage,
                      imageFile: state is CreateDoctorUploadPracticingFrontImage
                          ? File(state.file.path)
                          : null,
                      onTap: () async {
                        await createDoctorCubit.uploadPracticingFrontImage(context: context);
                      },
                    );
                  },
                ),

                const SizedBox(
                  height: 4,
                ),
                Label(
                  text: LocaleKeys.front.localize,
                  style: Styles.mediumText(
                    fontSize: 24,
                    height: 1.60,
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 16,
            ),
            Column(
              children: [
                // BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
                //   buildWhen: (previous, current) =>
                //       current is CreateDoctorUploadPracticingBehindImage ||
                //       current is CreateDoctorInitial,
                //   builder: (context, state) {
                //     return CustomImagePickerHealth(
                //       isUploaded:
                //           state is CreateDoctorUploadPracticingBehindImage,
                //       onTap: () async {
                //         await createDoctorCubit.uploadPracticingBehindImage(
                //             context: context);
                //       },
                //     );
                //     // if (state is CreateDoctorUploadPracticingFrontImage) {
                //     //   return ImagePickerPlaceholder(
                //     //     image: Image.file(
                //     //       File(state.file.path),
                //     //     ),
                //     //   );
                //     // }
                //     // return ImagePickerPlaceholder(
                //     //   title: context.isArabic ? 'الوجه' : 'Front',
                //     // );
                //   },
                // ),
                BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
                  buildWhen: (previous, current) =>
                  current is CreateDoctorUploadPracticingBehindImage ||
                      current is CreateDoctorInitial,
                  builder: (context, state) {
                    return CustomImagePickerHealth(
                      isUploaded: state is CreateDoctorUploadPracticingBehindImage,
                      imageFile: state is CreateDoctorUploadPracticingBehindImage
                          ? File(state.file.path)
                          : null,
                      onTap: () async {
                        await createDoctorCubit.uploadPracticingBehindImage(context: context);
                      },
                    );
                  },
                ),

                const SizedBox(
                  height: 4,
                ),
                Label(
                  text: LocaleKeys.back.localize,
                  style: Styles.mediumText(
                    fontSize: 24,
                    height: 1.60,
                  ),
                ),
              ],
            ),
            // InkWell(
            //   onTap: () async {
            //     await createDoctorCubit.uploadPracticingBehindImage(
            //         context: context);
            //   },
            //   child: BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
            //     buildWhen: (previous, current) =>
            //         current is CreateDoctorUploadPracticingBehindImage ||
            //         current is CreateDoctorInitial,
            //     builder: (context, state) {
            //       if (state is CreateDoctorUploadPracticingBehindImage) {
            //         return ImagePickerPlaceholder(
            //           image: Image.file(
            //             File(state.file.path),
            //           ),
            //         );
            //       }
            //       return ImagePickerPlaceholder(
            //         title: context.isArabic ? 'الخلف' : 'Back',
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
