import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateRestaurantLicensePhotoPicker extends StatelessWidget {
  const CreateRestaurantLicensePhotoPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final createRestaurantCubit = context.read<CreateRestaurantCubit>();
    return BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
        builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            text:
                context.isArabic ? 'السجل التجاري' : 'The Commercial Register',
            style: Styles.headerText(),
          ),
          const Sizer(),
          FittedBox(
            child: Row(
              children: [
                InkWell(
                  onTap: () async {
                    await createRestaurantCubit.uploadLicenseFirstPageImage();
                  },
                  child:
                      BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
                    buildWhen: (previous, current) =>
                        current
                            is CreateRestaurantUploadLicenseFirstPageImage ||
                        current is CreateRestaurantInitial,
                    builder: (context, state) {
                      if (state
                          is CreateRestaurantUploadLicenseFirstPageImage) {
                        return ImagePickerPlaceholder(
                          image: Image.file(
                            File(state.file.path),
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                      return ImagePickerPlaceholder(
                        borderColor: state is ValidationState &&
                                (state.isCommercialFirstPage ?? true)
                            ? Colors.red
                            : Colors.grey,
                        title:
                            context.isArabic ? 'الصفحة الأولي' : 'First Page',
                      );
                    },
                  ),
                ),
                const Sizer(),
                InkWell(
                  onTap: () async {
                    await createRestaurantCubit.uploadLicenseSecondPageImage();
                  },
                  child:
                      BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
                    buildWhen: (previous, current) =>
                        current
                            is CreateRestaurantUploadLicenseSecondPageImage ||
                        current is CreateRestaurantInitial,
                    builder: (context, state) {
                      if (state
                          is CreateRestaurantUploadLicenseSecondPageImage) {
                        return ImagePickerPlaceholder(
                          image: Image.file(
                            File(state.file.path),
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                      return ImagePickerPlaceholder(
                        borderColor: state is ValidationState &&
                                (state.isCommercialSecondPage ?? true)
                            ? Colors.red
                            : Colors.grey,
                        title:
                            context.isArabic ? 'الصفحة الثانية' : 'Second Page',
                      );
                    },
                  ),
                ),
                const Sizer(),
                InkWell(
                  onTap: () async {
                    await createRestaurantCubit.uploadLicenseThiredPageImage();
                  },
                  child:
                      BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
                    buildWhen: (previous, current) =>
                        current
                            is CreateRestaurantUploadLicenseThiredPageImage ||
                        current is CreateRestaurantInitial,
                    builder: (context, state) {
                      if (state
                          is CreateRestaurantUploadLicenseThiredPageImage) {
                        return ImagePickerPlaceholder(
                          image: Image.file(
                            File(state.file.path),
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                      return ImagePickerPlaceholder(
                        borderColor: state is ValidationState &&
                                (state.isCommercialThirdPage ?? true)
                            ? Colors.red
                            : Colors.grey,
                        title:
                            context.isArabic ? 'الصفحة الثالثة' : 'Third Page',
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible:
                state is ValidationState && (state.isCommercialPhoto ?? true),
            child: Padding(
              padding: const EdgeInsets.only(right: 5, left: 5, top: 5.0),
              child: Text(
                LocaleKeys
                    .youHaveToUploadThe3PagesOfCommercialRegistration.localize,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          )
        ],
      );
    });
  }
}
