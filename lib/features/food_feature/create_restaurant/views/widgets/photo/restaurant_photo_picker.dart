import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateRestaurantProfilePhotoPicker extends StatefulWidget {
  const CreateRestaurantProfilePhotoPicker({super.key});

  @override
  State<CreateRestaurantProfilePhotoPicker> createState() =>
      _CreateRestaurantProfilePhotoPickerState();
}

class _CreateRestaurantProfilePhotoPickerState
    extends State<CreateRestaurantProfilePhotoPicker> {
  @override
  Widget build(BuildContext context) {
    final createRestaurantCubit = context.read<CreateRestaurantCubit>();
    return BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
        builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            text: LocaleKeys.photoForRestaurant.tr(),
            style: Styles.headerText(),
          ),
          const Sizer(),
          BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
            buildWhen: (previous, current) =>
                current is CreateRestaurantUploadProfileImage ||
                current is CreateRestaurantInitial,
            builder: (context, state) {
              return Wrap(
                runSpacing: 10,
                spacing: 10,
                children: [
                  if (state is CreateRestaurantUploadProfileImage) ...[
                    ...state.files.map(
                      (e) => ImagePickerPlaceholder(
                        tilte: e.path.split('/').last,
                        image: Image.file(
                          File(e.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                  InkWell(
                    onTap: () async {
                      await createRestaurantCubit.uploadProfileImage();
                    },
                    child: BlocBuilder<CreateRestaurantCubit,
                        CreateRestaurantState>(builder: (context, state) {
                      return ImagePickerPlaceholder(
                        borderColor: state is ValidationState &&
                                (state.isRestaurantPhoto ?? true)
                            ? Colors.red
                            : Colors.black,
                      );
                    }),
                  ),
                ],
              );
            },
          ),
          Visibility(
            visible: state is ValidationState && (state.isName ?? true),
            child: const Padding(
              padding: EdgeInsets.only(right: 5, left: 5, top: 5.0),
              child: Text(
                "You have to uplaod at least one photo!",
                style: TextStyle(color: Colors.red),
              ),
            ),
          )
        ],
      );
    });
  }
}
